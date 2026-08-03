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
    
    var searchResults: [PokeAPIElement] {
        if search.isEmpty {
            return viewModel.pokemonArray
        } else {
            return viewModel.pokemonArray.filter { $0.name.contains(search.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            Text("Bienvenido a la PokeDex de SwiftUI!")
                .font(.headline)
                .padding()
            
            List {
                ForEach(searchResults) { pokemon in
                    Button {
                        print("Navegando a...")
                        Task {
                            await viewModel.fetchPokemonDetail(url: pokemon.url)
                        }
                        
                    } label: {
                        ListCell(pokemon: pokemon)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreIfNeeded(pokemon)
                                }
                            }
                    }
                    .contentShape(Rectangle())
                    .tint(.primary)
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .onChange(of: viewModel.selectedPokemon) {
                guard let pokemon = viewModel.selectedPokemon else { return }
                router.push(to: .pokemonDetail(pokemon))
            }
            .searchable(text: $search)
            .refreshable {
                await viewModel.fetchPokemonList()
                
            }
        }
        .task {
            viewModel.pokemonArray.removeAll()
            await viewModel.fetchPokemonList()
        }
    }
}

#Preview {
    ListView(viewModel: ListViewModel())
}
