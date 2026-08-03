//
//  APIServices.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

protocol ServiceProtocol {
    @MainActor func getPokemonList(url: String?, completion: @escaping (Result<([PokeAPIElement], String), NetworkError>) -> Void) async
    @MainActor func getPokemonDetail(url: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) async
}

enum Endpoints: String {
    case pokemon = "https://pokeapi.co/api/v2/pokemon"
}

struct APIServices: ServiceProtocol {
    var networkManager = NetworkManager()
    
    func getPokemonList(url: String?, completion: @escaping (Result<([PokeAPIElement], String), NetworkError>) -> Void) async {
        do {
            if let nextUrl = url {
                let response: PokeAPIResponse = try await networkManager.request(endpoint: nextUrl)
                let pokemon = response.results
                guard let next = response.next else { return }
                completion(.success((pokemon, next)))
            } else {
                let response: PokeAPIResponse = try await networkManager.request(endpoint: Endpoints.pokemon.rawValue)
                let pokemon = response.results
                guard let next = response.next else { return }
                completion(.success((pokemon, next)))
            }
        } catch {
            completion(.failure(error as! NetworkError))
        }
    }
    
    func getPokemonDetail(url: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) async {
        do {
            let pokemon: Pokemon = try await networkManager.request(endpoint: url)
            completion(.success(pokemon))
            
        } catch {
            completion(.failure(error as! NetworkError))
        }
        
    }
}
