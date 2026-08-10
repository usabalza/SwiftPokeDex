//
//  ListView.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI
import SwiftData

struct ListView: View {
    // MARK: - Estado y Dependencias
    @StateObject var viewModel = ListViewModel()
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
                    pokemonListContent // 👈 Primer nivel de abstracción
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
        .environmentObject(router)
        .task {
            if viewModel.pokemonList.isEmpty {
                await viewModel.loadPokemonPage()
            }
        }
    }
}

// MARK: - Extensiones de Modularización Visual (@ViewBuilder)
extension ListView {
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
                    // Si manejas una paleta, puedes usar colores personalizados aquí
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
    
    /// Orquestador central del contenido dentro del LazyVStack
    @ViewBuilder
    private var pokemonListContent: some View {
        let displayList = viewModel.filteredPokemon(favoriteIds: favoriteIds)
        
        if displayList.isEmpty && viewModel.isLoading && viewModel.selectedTag == .all {
            initialLoadPlaceholders
        } else {
            mainListView(displayList: displayList)
        }
    }
    
    /// Muestra las celdas grises animadas de la carga inicial
    @ViewBuilder
    private var initialLoadPlaceholders: some View {
        ForEach(initialPlaceholders, id: \.self) { _ in
            PokemonRowPlaceholder()
        }
    }
    
    /// Bucle principal encargado de pintar las celdas reales y los esqueletos inferiores de paginación
    @ViewBuilder
    private func mainListView(displayList: [PokemonDetail]) -> some View {
        ForEach(displayList) { pokemon in
            let isFav = favoriteIds.contains(pokemon.id)
            Button {
                print("El router \(router) está navegando hacia el pokemon \(pokemon)")
                router.push(to: .pokemonDetail(pokemon))
            } label: {
                ListCell(
                    pokemon: pokemon,
                    isFavorite: isFav,
                    onFavorite: toggleFavorite
                )
            }
            .buttonStyle(.plain)

            
            .onAppear {
                // Lógica de paginación proactiva controlada
                if viewModel.searchText.isEmpty && viewModel.selectedTag == .all && pokemon.id == viewModel.pokemonList.last?.id {
                    Task { await viewModel.loadPokemonPage() }
                }
            }
        }
        
        // Esqueletos de carga inferior si estamos haciendo scroll hacia abajo
        if viewModel.isLoading && !viewModel.pokemonList.isEmpty && viewModel.selectedTag == .all {
            ForEach(paginationPlaceholders, id: \.self) { _ in
                PokemonRowPlaceholder()
            }
        }
    }
    
    /// Controlador lógico para persistir o borrar elementos de SwiftData
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
    ListView(viewModel: ListViewModel())
}
