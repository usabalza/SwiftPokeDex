//
//  Pokemon.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import Foundation

public struct Pokemon: Codable, Identifiable, Equatable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let sprites: Sprite
}
