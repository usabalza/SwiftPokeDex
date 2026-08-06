//
//  ListCell.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI

struct ListCell: View {
    
    var pokemon: PokemonDetail
    @State var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: pokemon.sprites.frontDefault)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    // Tu esqueleto animado (Shimmer) que repara el bug visual previo
                    Circle()
                        .fill(Color(.systemGray5))
                }
                .frame(width: 60, height: 60)
                
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
                        isFavorite.toggle()
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
            .padding(.horizontal, 10)
            .contentShape(Rectangle())
        }
        .padding(20)
        
    }
    
}

struct TypeCapsule: View {
    var types: [TypeElement]
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(types) { typeSlot in
                Text(typeSlot.type.name.capitalized)
                    .font(.caption2)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(TypeColor(rawValue: typeSlot.type.name)?.color ?? .gray) // Extensión de color personalizada
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
    }
}
