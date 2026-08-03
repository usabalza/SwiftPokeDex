//
//  ListCell.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import SwiftUI

struct ListCell: View {
    
    var pokemon: PokeAPIElement
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(pokemon.name.capitalized)
                .font(.headline)
        }
    }
    
}
