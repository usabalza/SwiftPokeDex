//
//  ListView.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: ListViewModel
    @State var search: String = ""
    
    // 1. Generamos identificadores estables y únicos para la carga inicial
    private let initialPlaceholders = (0..<6).map { _ in UUID() }
    // 2. Generamos identificadores para la carga al hacer scroll (paginación)
    private let paginationPlaceholders = (0..<2).map { _ in UUID() }
    
    var searchResults: [PokemonDetail] {
        if search.isEmpty {
            return viewModel.pokemonList
        } else {
            return viewModel.pokemonList.filter { $0.name.contains(search.lowercased()) }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.pokemonList.isEmpty && viewModel.isLoading {
                    ForEach(initialPlaceholders, id: \.self) { _ in
                        PokemonRowPlaceholder()
                    }
                } else {
                    ForEach(viewModel.filteredPokemon) { pokemon in
                        // Tu celda personalizada que ya creaste
                        Button {
                            router.push(to: .pokemonDetail(pokemon))
                            print(pokemon)
                        } label: {
                            ListCell(pokemon: pokemon)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            // Paginación: Si llegamos al último, cargamos más
                            if pokemon.id == viewModel.pokemonList.last?.id {
                                Task { await viewModel.loadPokemonPage() }
                            }
                        }
                    }
                    if viewModel.isLoading && !viewModel.pokemonList.isEmpty {
                        ForEach(paginationPlaceholders, id: \.self) { _ in
                            PokemonRowPlaceholder()
                        }
                    }
                }
                
            }
        }
        .navigationTitle("Swift PokéDex for iOS")
        // 1. 👇 AÑADE EL BUSCADOR NATIVO
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Buscar por nombre o número..."
        )
        // 2. 👇 AÑADE EL PULL TO REFRESH NATIVO
        .refreshable {
            await viewModel.refreshData()
        }
        .task {
            // Carga inicial al abrir la app
            if viewModel.pokemonList.isEmpty {
                await viewModel.loadPokemonPage()
            }
        }
    }
}

#Preview {
    ListView(viewModel: ListViewModel())
}
