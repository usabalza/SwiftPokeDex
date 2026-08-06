//
//  APIServices.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

protocol ServiceProtocol {
    @MainActor func fetchPokemonList(limit: Int, offset: Int) async throws -> [PokemonRemoteItem]
    @MainActor func fetchPokemonDetail(from urlString: String) async throws -> PokemonDetail
    @MainActor func fetchDetailedPokemonList(limit: Int, offset: Int) async throws -> [PokemonDetail]

}

struct APIServices: ServiceProtocol {
    var networkManager = NetworkManager()
    var baseUrl = "https://pokeapi.co/api/v2/pokemon"
    
    // 1. Obtener lista básica
    func fetchPokemonList(limit: Int = 20, offset: Int = 0) async throws -> [PokemonRemoteItem] {
        let urlString = "\(baseUrl)?limit=\(limit)&offset=\(offset)"
        let response: PokemonListResponse = try await networkManager.request(endpoint: urlString)
        return response.results
    }

    // 2. Obtener detalle individual
    func fetchPokemonDetail(from urlString: String) async throws -> PokemonDetail {
        return try await networkManager.request(endpoint: urlString)
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
}
