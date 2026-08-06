//
//  Response.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonRemoteItem]
}

struct PokemonRemoteItem: Codable {
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}
