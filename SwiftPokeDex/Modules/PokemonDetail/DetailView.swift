//
//  DetailView.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewModel: DetailViewModel
    var pokemon: PokemonDetail
    
    var body: some View {
        HStack {
            Text("#\(pokemon.id) - \(pokemon.name.capitalized)")
                .font(.largeTitle)
            
            //AsyncImage(url: URL(string: pokemon.sprites.frontDefault))
        }
        
        TypeCapsule(types: pokemon.types)
    }
}
