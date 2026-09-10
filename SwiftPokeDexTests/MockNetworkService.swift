//
//  MockNetworkService.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 21/8/26.
//


import Foundation
@testable import SwiftPokeDex

class MockNetworkService: ServiceProtocol {
    
    // Propiedades para controlar el comportamiento del Mock en cada test
    var shouldReturnError = false
    var mockPokemonDetails: [PokemonDetail] = []
    var mockEvolutionLine: [EvolutionLink] = []
    
    func fetchDetailedPokemonList(limit: Int, offset: Int) async throws -> [PokemonDetail] {
        if shouldReturnError {
            throw URLError(.notConnectedToInternet)
        }
        return mockPokemonDetails
    }
    
    func fetchPokemonDetail(from urlString: String) async throws -> PokemonDetail {
        if shouldReturnError {
            throw URLError(.notConnectedToInternet)
        }
        guard let first = mockPokemonDetails.first else {
            throw URLError(.badServerResponse)
        }
        return first
    }
     
    func fetchPokemonDetail(pokemonId: Int) async throws -> PokemonDetail {
        if shouldReturnError {
            throw URLError(.notConnectedToInternet)
        }
        guard let first = mockPokemonDetails.first else {
            throw URLError(.badServerResponse)
        }
        return first
    }
    
    func fetchEvolutionLine(for pokemonId: Int) async throws -> [EvolutionLink] {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockEvolutionLine
    }
}
