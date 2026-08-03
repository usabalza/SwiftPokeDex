//
//  Response.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import Foundation

struct PokeAPIResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokeAPIElement]
}

struct PokeAPIElement: Codable, Identifiable, Equatable {
    var id = UUID()
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}
