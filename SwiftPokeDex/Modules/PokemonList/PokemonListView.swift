//
//  ListView.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI
import SwiftData

struct PokemonListView: View {
    // MARK: - Estado y Dependencias
    @StateObject private var viewModel = PokemonListViewModel()
    @EnvironmentObject private var router: Router
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteList: [FavoritePokemon]
    
    // Identificadores únicos para evitar duplicados estéticos
    private let initialPlaceholders = (0..<6).map { _ in UUID() }
    private let paginationPlaceholders = (0..<2).map { _ in UUID() }
    
    private var favoriteIds: [Int] {
        favoriteList.map { $0.id }
    }
    
    // MARK: - Body Principal (Limpio y Escaneable)
    var body: some View {
        VStack {
            filterTags
            Divider()
            ScrollView {
                LazyVStack(spacing: 12) {
                    pokemonListContent 
                }
                .padding(.horizontal)
            }
        }
        
        .navigationTitle("PokéDex for iOS")
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Buscar..."
        )
        .refreshable {
            if viewModel.selectedTag == .all {
                await viewModel.refreshData()
            }
        }
        .task {
            if viewModel.pokemonList.isEmpty {
                await viewModel.loadPokemonPage()
            }
        }
    }
}

// MARK: - Extensiones de Modularización Visual (@ViewBuilder)
extension PokemonListView {
    /// Vista del filtro
    @ViewBuilder
    private var filterTags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ListFilterTag.allCases, id: \.self) { tag in
                    let isSelected = viewModel.selectedTag == tag
                    
                    Text(tag.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isSelected ? Color.blue : Color(.systemGray6))
                        .foregroundColor(isSelected ? .white : .primary)
                        .clipShape(Capsule())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.selectedTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var pokemonListContent: some View {
        let displayList = viewModel.filteredPokemon(favoriteIds: favoriteIds)
        if let errorMessage = viewModel.errorMessage, displayList.isEmpty {
            NetworkErrorView(message: errorMessage) {
                Task {
                    await viewModel.loadPokemonPage()
                }
            }
        }
        else if viewModel.selectedTag == .favorites && displayList.isEmpty {
            emptyListPlaceholder
        }
        else if displayList.isEmpty && viewModel.isLoading && viewModel.selectedTag == .all {
            initialLoadPlaceholders
        } else {
            mainListView(displayList: displayList)
        }
    }
    
    @ViewBuilder
    private var initialLoadPlaceholders: some View {
        ForEach(initialPlaceholders, id: \.self) { _ in
            PokemonRowPlaceholder()
        }
    }
    
    @ViewBuilder
    private var emptyListPlaceholder: some View {
        ContentUnavailableView {
            Label("No hay favoritos", systemImage: "heart.slash")
                .font(.title2)
                .bold()
                .foregroundColor(.secondary)
        } description: {
            Text("Los Pokémon que marques con un corazón aparecerán en esta sección de forma permanente.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.top, 60)
    }
    
    @ViewBuilder
    private func mainListView(displayList: [PokemonDetail]) -> some View {
        ForEach(displayList) { pokemon in
            let isFav = favoriteIds.contains(pokemon.id)
            Button {
                router.push(to: .pokemonDetail(pokemon))
            } label: {
                PokemonRowView(
                    pokemon: pokemon,
                    isFavorite: isFav,
                    onFavorite: toggleFavorite
                )
            }
            .buttonStyle(.plain)
            
            
            .onAppear {
                if viewModel.searchText.isEmpty && viewModel.selectedTag == .all && pokemon.id == viewModel.pokemonList.last?.id {
                    Task { await viewModel.loadPokemonPage() }
                }
            }
        }
        
        if viewModel.isLoading && !viewModel.pokemonList.isEmpty && viewModel.selectedTag == .all {
            ForEach(paginationPlaceholders, id: \.self) { _ in
                PokemonRowPlaceholder()
            }
        }
    }

    private func toggleFavorite(for pokemon: PokemonDetail, currentlyFav: Bool) {
        if currentlyFav {
            if let existingFav = favoriteList.first(where: { $0.id == pokemon.id }) {
                modelContext.delete(existingFav)
            }
        } else {
            let newFav = FavoritePokemon(
                id: pokemon.id,
                name: pokemon.name,
                type: pokemon.types.first?.type.name ?? "unknown",
                imageURL: pokemon.sprites.versions.generationIx.scarletViolet.frontDefault ?? ""
            )
            modelContext.insert(newFav)
        }
        do {
            try modelContext.save()
            print("💾 Base de datos guardada exitosamente en el disco.")
        } catch {
            print("❌ Error al persistir los datos: \(error.localizedDescription)")
        }
    }
}

#Preview {
    PokemonListView()
}
