//
//  ListViewModel.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI
import Combine

enum ListFilterTag: String, CaseIterable {
    case all = "Todos"
    case favorites = "Favoritos"
}

class PokemonListViewModel: ObservableObject {
    
    let services: ServiceProtocol
    
    @Published var pokemonList: [PokemonDetail] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText = ""
    @Published var selectedTag: ListFilterTag = .all
    
    private var currentOffset = 0
    private let limit = 20
    
    init(services: ServiceProtocol = APIServices()) {
        self.services = services
    }
    
    func filteredPokemon(favoriteIds: [Int]) -> [PokemonDetail] {
        var baseList = pokemonList
        if selectedTag == .favorites {
            baseList = pokemonList.filter { favoriteIds.contains($0.id) }
        }
        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter { pokemon in
                pokemon.name.localizedCaseInsensitiveContains(searchText) ||
                String(format: "#%03d", pokemon.id).contains(searchText)
            }
        }
    }
    
    func loadPokemonPage() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newPokemon = try await services.fetchDetailedPokemonList(
                limit: limit,
                offset: currentOffset
            )
            
            self.pokemonList.append(contentsOf: newPokemon)
            self.currentOffset += limit
        } catch {
            self.errorMessage = "Error al cargar los datos: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let freshPokemon = try await services.fetchDetailedPokemonList(
                limit: limit,
                offset: 0
            )
            self.currentOffset = limit
            self.pokemonList = freshPokemon
            
        } catch {
            self.errorMessage = "Error al refrescar: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
