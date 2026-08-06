//
//  Pokemon.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 15/6/26.
//

import Foundation

public struct PokemonDetail: Codable, Identifiable {
    public let id: Int
    let name: String
    let sprites: SpriteVersions
    let types: [TypeElement]
}

// 1. Entramos a la raíz de sprites
struct SpriteVersions: Codable {
    let frontDefault: String
    let versions: GenerationVersions
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case versions
    }
}

// 2. Mapeamos el contenedor de generaciones
struct GenerationVersions: Codable {
    let generationIx: GameVersions
    
    enum CodingKeys: String, CodingKey {
        case generationIx = "generation-ix" // 👈 Resuelve el guion del JSON
    }
}

struct GameVersions: Codable {
    let scarletViolet: ScarletVioletPath
    
    enum CodingKeys: String, CodingKey {
        case scarletViolet = "scarlet-violet"
    }
}

// 3. Entramos al nodo final de iconos de Gen 9
struct ScarletVioletPath: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeElement: Codable, Identifiable {
    var id = UUID()
    let type: TypeInfo
    
    enum CodingKeys: String, CodingKey {
        case type
    }
}

struct TypeInfo: Codable {
    let name: String
}
