//
//  TypeCapsule.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 20/8/26.
//

import SwiftUI

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
                    .background(TypeColor(rawValue: typeSlot.type.name)?.color ?? .gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
    }
}
