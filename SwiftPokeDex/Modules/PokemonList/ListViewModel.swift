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

class ListViewModel: ObservableObject {
    
    let services = APIServices()
    
    @Published var pokemonList: [PokemonDetail] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText = "" // 👈 Vinculado al buscador
    @Published var selectedTag: ListFilterTag = .all // 👈 Tag seleccionado por defecto
    
    private var currentOffset = 0
    private let limit = 20
    
    // 👈 Propiedad computada para filtrar la lista en tiempo real
    func filteredPokemon(favoriteIds: [Int]) -> [PokemonDetail] {
        // 1. Primero filtramos según el Tag ("Todos" o "Favoritos")
        var baseList = pokemonList
        if selectedTag == .favorites {
            baseList = pokemonList.filter { favoriteIds.contains($0.id) }
        }
        
        // 2. Después aplicamos el filtro de texto de la barra de búsqueda
        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter { pokemon in
                pokemon.name.localizedCaseInsensitiveContains(searchText) ||
                String(pokemon.id).contains(searchText)
            }
        }
    }
    
    func loadPokemonPage() async {
        guard !isLoading else { return } // Evita peticiones duplicadas
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newPokemon = try await services.fetchDetailedPokemonList(
                limit: limit,
                offset: currentOffset
            )
            
            self.pokemonList.append(contentsOf: newPokemon)
            self.currentOffset += limit // Prepara el offset para la siguiente página
        } catch {
            self.errorMessage = "Error al cargar los datos: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // 👈 Método para el Pull-to-Refresh
    
    func refreshData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Descargamos el primer bloque (offset 0) en una variable local
            let freshPokemon = try await services.fetchDetailedPokemonList(
                limit: limit,
                offset: 0
            )
            
            // 2. Si la red responde bien, reiniciamos los estados de la paginación
            self.currentOffset = limit
            
            // 3. Reemplazamos la lista completa de un solo golpe
            // Esto evita que la UI se quede vacía a mitad de la petición de red
            self.pokemonList = freshPokemon
            
        } catch {
            self.errorMessage = "Error al refrescar: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
