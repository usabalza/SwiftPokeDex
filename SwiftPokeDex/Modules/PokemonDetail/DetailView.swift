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
    var pokemon: Pokemon
    
    var body: some View {
        HStack {
            Text("#\(pokemon.id) - \(pokemon.name.capitalized)")
                .font(.largeTitle)
            
            AsyncImage(url: URL(string: pokemon.sprites.frontDefault))
        }
        
        
        if pokemon.types.count == 1 {
            Text(pokemon.types[0].type.name.capitalized)
                .font(.title)
                .foregroundStyle(TypeColor(rawValue: pokemon.types[0].type.name)?.color ?? .gray)
        } else {
            HStack {
                Text(pokemon.types[0].type.name.capitalized)
                    .font(.title)
                    .foregroundStyle(TypeColor(rawValue: pokemon.types[0].type.name)?.color ?? .gray)
                Text(pokemon.types[1].type.name.capitalized)
                    .font(.title)
                    .foregroundStyle(TypeColor(rawValue: pokemon.types[1].type.name)?.color ?? .gray)
            }
            
        }
    }
}
