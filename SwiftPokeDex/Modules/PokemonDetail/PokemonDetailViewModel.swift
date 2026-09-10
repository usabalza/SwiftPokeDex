//
//  DetailViewModel.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 24/6/26.
//

import SwiftUI
import Combine

class PokemonDetailViewModel: ObservableObject {
    
    let services: ServiceProtocol
    let pokemon: PokemonDetail
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var evolutionArray: [EvolutionLink] = []
    
    
    init(pokemon: PokemonDetail, services: ServiceProtocol = APIServices()) {
        self.pokemon = pokemon
        self.services = services
    }
    
    func getEvolutionLine() async {
        guard !isLoading && evolutionArray.isEmpty else { return } // Evita peticiones duplicadas
        
        isLoading = true
        errorMessage = nil
        evolutionArray = []
        
        do {
            let evolutionLine = try await services.fetchEvolutionLine(for: pokemon.id)
            evolutionArray = evolutionLine
            print(evolutionArray)
            
        } catch {
            self.errorMessage = "Error al cargar los datos: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func getNextPokemonDetail(pokemonId: Int) async -> PokemonDetail? {
        guard !isLoading else { return nil } // Evita peticiones duplicadas
        
        isLoading = true
        errorMessage = nil
        
        do {
            let next = try await services.fetchPokemonDetail(pokemonId: pokemonId)
            return next
        } catch {
            self.errorMessage = "Error al cargar los datos: \(error.localizedDescription)"
            return nil
        }
    }
    
}
