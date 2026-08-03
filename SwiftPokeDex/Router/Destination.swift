//
//  Destination.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

public enum Destination: Hashable {
    case pokemonList
    case pokemonDetail(_ pokemon: Pokemon)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .pokemonList:
            hasher.combine(0)
        case .pokemonDetail(let pokemon):
            hasher.combine(1)
            hasher.combine(pokemon.id)
        }
    }
}
