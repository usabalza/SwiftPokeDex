//
//  PokemonRowPlaceholder.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 6/8/26.
//

import SwiftUI

struct PokemonRowPlaceholder: View {
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.gray)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
                    .frame(width: 40, height: 12)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
                    .frame(width: 140, height: 18)
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray)
                        .frame(width: 50, height: 16)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray)
                        .frame(width: 50, height: 16)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shimmer()
    }
}
