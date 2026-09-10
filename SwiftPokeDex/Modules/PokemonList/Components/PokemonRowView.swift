//
//  ListCell.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI

struct PokemonRowView: View {
    
    var pokemon: PokemonDetail
    var isFavorite: Bool
    var onFavorite: (PokemonDetail, Bool) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 60)
                    
                    AsyncImage(url: URL(string: pokemon.sprites.frontDefault)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .fill(Color(.systemGray5))
                    }
                    .frame(width: 60, height: 60)
                    
                }
                
                
                VStack(alignment: .leading) {
                    Text("#\(String(format: "%03d", pokemon.id))")
                        .font(.caption)
                    
                    Text(pokemon.name.capitalized)
                        .font(.headline)
                    
                    TypeCapsule(types: pokemon.types)
                }
                
                Spacer()
                HStack(spacing: 12) {
                    Button {
                        onFavorite(pokemon, isFavorite)
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .black)
                            .font(.title3)
                            .padding(4)
                    }
                    .buttonStyle(.plain)
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
            }
            .contentShape(Rectangle())
        }
        .padding(20)
        
    }
    
}
