//
//  APIServices.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

protocol ServiceProtocol {
    @MainActor func fetchPokemonDetail(from urlString: String) async throws -> PokemonDetail
    @MainActor func fetchPokemonDetail(pokemonId: Int) async throws -> PokemonDetail
    @MainActor func fetchDetailedPokemonList(limit: Int, offset: Int) async throws -> [PokemonDetail]
    @MainActor func fetchEvolutionLine(for pokemonId: Int) async throws -> [EvolutionLink]

}

struct APIServices: ServiceProtocol {
    var networkManager = NetworkManager()
    
    // 1. Obtener lista básica
    private func fetchPokemonList(limit: Int = 20, offset: Int = 0) async throws -> [PokemonRemoteItem] {
        let response: PokemonListResponse = try await networkManager.request(endpoint: Endpoints.pokemonList(limit: limit, offset: offset).urlString)
        return response.results
    }

    // 2. Obtener detalle individual
    func fetchPokemonDetail(from urlString: String) async throws -> PokemonDetail {
        return try await networkManager.request(endpoint: urlString)
    }
    
    func fetchPokemonDetail(pokemonId: Int) async throws -> PokemonDetail {
        return try await networkManager.request(endpoint: Endpoints.pokemonDetail(id: pokemonId).urlString)
    }

    // 3. El TaskGroup se mantiene igual de eficiente, pero usando las funciones limpias
    func fetchDetailedPokemonList(limit: Int = 20, offset: Int = 0) async throws -> [PokemonDetail] {
        let remoteItems = try await fetchPokemonList(limit: limit, offset: offset)
        
        return try await withThrowingTaskGroup(of: PokemonDetail.self) { group in
            for item in remoteItems {
                group.addTask {
                    return try await self.fetchPokemonDetail(from: item.url)
                }
            }
            
            var pokemonDetails: [PokemonDetail] = []
            for try await detail in group {
                pokemonDetails.append(detail)
            }
            return pokemonDetails.sorted { $0.id < $1.id }
        }
    }
    
    // 1. Obtiene el endpoint de evolución desde la especie del Pokémon
    private func fetchEvolutionChainURL(pokemonId: Int) async throws -> String {
        let response: SpeciesResponse = try await networkManager.request(endpoint: Endpoints.pokemonSpecies(id: pokemonId).urlString)
        return response.evolutionChain.url
    }
    
    // 2. Descarga la cadena y la aplana en una lista ordenada
    func fetchEvolutionLine(for pokemonId: Int) async throws -> [EvolutionLink] {
        let chainURL = try await fetchEvolutionChainURL(pokemonId: pokemonId)
        let response: EvolutionChainResponse = try await networkManager.request(endpoint: chainURL)
        
        var links: [EvolutionLink] = []
        var currentNode: ChainNode? = response.chain
        
        // Recorremos el árbol recursivo de forma lineal
        while let node = currentNode {
            let pId = node.species.id
            // Usamos la URL oficial de artworks en HD de la novena generación o fallback
            
            links.append(EvolutionLink(id: pId, name: node.species.name, imageURL: Endpoints.artworks(id: pId).urlString))
            currentNode = node.evolvesTo.first // Toma la siguiente evolución directa
        }
        
        return links
    }
}
