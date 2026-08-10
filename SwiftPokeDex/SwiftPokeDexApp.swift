//
//  SwiftPokeDexApp.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI
import SwiftData

@main
struct SwiftPokeDexApp: App {
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                let viewModel = ListViewModel()
                ListView(viewModel: viewModel)
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .pokemonList:
                            EmptyView()
                        case .pokemonDetail(let pokemon):
                            let viewModel = DetailViewModel()
                            DetailView(viewModel: viewModel, pokemon: pokemon)
                        }
                    }
            }
            .environmentObject(router)
        }
        .modelContainer(for: FavoritePokemon.self)
    }
}
