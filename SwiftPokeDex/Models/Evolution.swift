//
//  Evolution.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 11/8/26.
//

import Foundation

struct EvolutionChainResponse: Decodable {
    let chain: ChainNode
}

struct SpeciesResponse: Decodable {
    let evolutionChain: ChainLink
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}

struct ChainLink: Decodable {
    let url: String
}

struct ChainNode: Decodable {
    let species: SpeciesShortInfo
    let evolvesTo: [ChainNode] // 👈 Estructura recursiva nativa
    
    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}

struct SpeciesShortInfo: Decodable {
    let name: String
    let url: String
    
    var id: Int {
        // Extrae el ID numérico al final de la URL (".../pokemon-species/1/")
        let components = url.split(separator: "/")
        return Int(components.last ?? "") ?? 1
    }
}

// Estructura simplificada que usaremos en la interfaz para pintar los eslabones
struct EvolutionLink: Identifiable, Hashable {
    let id: Int
    let name: String
    let imageURL: String
}
