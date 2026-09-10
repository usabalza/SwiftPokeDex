//
//  EvolutionChart.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 11/8/26.
//

import SwiftUI

struct EvolutionChart: View {
    let pokemonId: Int
    let evolutionLine: [EvolutionLink]
    let goToNextPokemon: (Int) -> Void
    
    @State private var isLoading = false
    @EnvironmentObject private var router: Router // 👈 Leemos el router centralizado
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Línea Evolutiva")
                .font(.title3)
                .bold()
            
            if isLoading {
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle().fill(Color.gray).frame(width: 60, height: 60).shimmer()
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(evolutionLine.enumerated()), id: \.element.id) { index, link in
                            let isCurrent = pokemonId == link.id
                            HStack(spacing: 12) {
                                Button {
                                    
                                    if isCurrent{
                                        return
                                    }
                                    goToNextPokemon(link.id)
                                } label: {
                                    VStack(spacing: 6) {
                                        AsyncImage(url: URL(string: link.imageURL)) { img in
                                            img.resizable().scaledToFit()
                                        } placeholder: {
                                            Circle().fill(isCurrent ? Color.blue.opacity(0.1) : Color(.systemGray5))
                                        }
                                        .frame(width: 70, height: 70)
                                        .background(Circle().fill(isCurrent ? Color.blue.opacity(0.1) : Color(.systemBackground)))
                                        
                                        Text(link.name.capitalized)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                if index < evolutionLine.count - 1 {
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}
