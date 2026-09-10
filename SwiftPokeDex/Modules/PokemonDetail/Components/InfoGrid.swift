//
//  InfoGrid.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 10/8/26.
//

import SwiftUI

struct InfoGrid: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            infoCard(title: "PESO", value: pokemon.formattedWeight, systemImage: "scalemass")

            infoCard(title: "ALTURA", value: pokemon.formattedHeight, systemImage: "ruler")

            VStack(alignment: .leading, spacing: 6) {
                Text("HABILIDADES")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(pokemon.abilities, id: \.ability.name) { slot in
                        Text(slot.ability.name.capitalized.replacingOccurrences(of: "-", with: " "))
                            .font(.system(size: 13, weight: slot.isHidden ? .regular : .semibold))
                            .foregroundColor(slot.isHidden ? .secondary : .primary)
                        
                        if slot.isHidden {
                            Text("(Oculta)")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .frame(height: 100)
    }
    
    @ViewBuilder
    private func infoCard(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
