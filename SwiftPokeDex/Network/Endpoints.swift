//
//  Endpoints.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 4/9/26.
//

import Foundation

enum Endpoints {
    case baseUrl
    case pokemonList(limit: Int, offset: Int)
    case pokemonDetail(id: Int)
    case pokemonSpecies(id: Int)
    case artworks(id: Int)
    
    private var pokemonBaseString: String {
        return "https://pokeapi.co/api/v2/"
    }
    
    private var artworkBaseString: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    }
    
    var urlString: String {
        switch self {
        case .baseUrl:
            return pokemonBaseString
        case .pokemonList(let limit, let offset):
            guard var components = URLComponents(string: "\(pokemonBaseString)pokemon") else { return "" }
            components.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            return components.url?.absoluteString ?? ""
        case .pokemonDetail(let id):
            return pokemonBaseString + "pokemon/\(id)/"
        case .pokemonSpecies(let id):
            return pokemonBaseString + "pokemon-species/\(id)"
        case .artworks(let id):
            return artworkBaseString + "\(id).png"
        }
    }
}
