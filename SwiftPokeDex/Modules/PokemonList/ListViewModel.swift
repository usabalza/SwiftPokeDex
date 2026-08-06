//
//  ListViewModel.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI
import Combine

class ListViewModel: ObservableObject {
    
    let services = APIServices()
    
    @Published var pokemonList: [PokemonDetail] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText = "" // 👈 Vinculado al buscador
    
    private var currentOffset = 0
    private let limit = 20
    
    // 👈 Propiedad computada para filtrar la lista en tiempo real
    var filteredPokemon: [PokemonDetail] {
        if searchText.isEmpty {
            return pokemonList
        } else {
            return pokemonList.filter { pokemon in
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
