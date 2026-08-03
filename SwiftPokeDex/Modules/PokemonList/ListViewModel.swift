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
    
    @Published var pokemonArray: [PokeAPIElement] = []
    @Published var selectedPokemon: Pokemon?
    @Published var nextUrl: String?
    var isLoading = false
    
    func fetchPokemonList(_ url: String? = nil) async {
        await services.getPokemonList(url: url) { result in
            switch result {
            case .success((let pokemonArray, let next)):
                self.pokemonArray.append(contentsOf: pokemonArray)
                self.nextUrl = next
                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMoreIfNeeded(_ current: PokeAPIElement) async {
        // Check if the item is near the end of the list
        if pokemonArray.last == current {
            await loadMore()
        }
    }
    
    private func loadMore() async {
        guard !isLoading else { return }
        isLoading = true
        
        await fetchPokemonList(nextUrl)
        
    }
    
    func fetchPokemonDetail(url: String) async {
        await services.getPokemonDetail(url: url) { result in
            switch result {
            case .success(let pokemon):
                self.selectedPokemon = pokemon
            case .failure(let error):
                print(error)
            }
        }
    }
}
