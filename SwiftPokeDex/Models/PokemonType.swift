//
//  PokemonType.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import Foundation
import SwiftUI

struct PokemonType: Codable {
    let slot: Int
    let type: TypeDetail
}

struct TypeDetail: Codable {
    let name: String
    let url: String
}

enum TypeColor: String, CaseIterable {
    case steel, water, bug, dragon, electric, ghost, fire, fairy, ice
    case fighting, normal, grass, psychic, rock, dark, ground, poison, flying
    
    // Diccionario interno con los códigos hexadecimales oficiales
    private var hexValue: String {
        switch self {
        case .steel: return "B7B7CE"
        case .water: return "6390F0"
        case .bug: return "A6B91A"
        case .dragon: return "6F35FC"
        case .electric: return "F7D02C"
        case .ghost: return "735797"
        case .fire: return "EE8130"
        case .fairy: return "D685AD"
        case .ice: return "96D9D6"
        case .fighting: return "C22E28"
        case .normal: return "A8A77A"
        case .grass: return "7AC74C"
        case .psychic: return "F95587"
        case .rock: return "B6A136"
        case .dark: return "705746"
        case .ground: return "E2BF65"
        case .poison: return "A33EA1"
        case .flying: return "A98FF3"
        }
    }
    
    // Retorna el color de SwiftUI procesando el hex
    var color: Color {
        Color(hex: self.hexValue)
    }
}

