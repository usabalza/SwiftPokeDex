//
//  DetailView.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel: PokemonDetailViewModel
    @State private var evolutionLine: [EvolutionLink] = []
    
    init(pokemon: PokemonDetail) {
        self._viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                DetailHeader(pokemon: viewModel.pokemon)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.pokemon.name.capitalized)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    InfoGrid(pokemon: viewModel.pokemon)
                    
                    StatsChart(pokemon: viewModel.pokemon)
                    
                    EvolutionChart(pokemonId: viewModel.pokemon.id, evolutionLine: viewModel.evolutionArray) { id in
                        Task {
                            if let detail = await viewModel.getNextPokemonDetail(pokemonId: id) {
                                router.push(to: .pokemonDetail(detail))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .task {
            // Carga asíncrona de la línea evolutiva al aparecer en pantalla
            await viewModel.getEvolutionLine()
        }
        .ignoresSafeArea(edges: .top) // Permite que el fondo de color llene la barra de estado superior
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Resorte visual hacia la pantalla de inicio
                    withAnimation(.easeInOut) {
                        router.popToRoot()
                    }
                } label: {
                    Image(systemName: "house.fill") // Icono nativo de casa
                        .font(.body)
                        .bold()
                }
            }
        }
    }
}

