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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

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
        //.modelContainer(sharedModelContainer)
    }
}
