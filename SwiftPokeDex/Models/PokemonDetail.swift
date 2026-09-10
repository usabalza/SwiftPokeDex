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
    let height: Int
    let weight: Int
    let sprites: SpriteVersions
    let types: [TypeElement]
    let abilities: [AbilitySlot]
    let stats: [StatSlot]
}

// 1. Entramos a la raíz de sprites
struct SpriteVersions: Codable {
    let frontDefault: String
    let other: OtherSprites
    let versions: GenerationVersions
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
        case versions
    }
}

struct OtherSprites: Codable {
    let officialArtwork: ArtworkPath
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct ArtworkPath: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
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

struct AbilitySlot: Codable, Hashable {
    let isHidden: Bool
    let ability: AbilityInfo
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case ability
    }
}

struct AbilityInfo: Codable, Hashable {
    let name: String
}

struct StatSlot: Codable, Hashable {
    let baseStat: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatInfo: Codable, Hashable {
    let name: String
}

struct PokemonChartStat: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
}

extension PokemonDetail {
    // Convierte decímetros a metros formateados (ej. 7 -> 0.7 m)
    var formattedHeight: String {
        let meters = Double(height) / 10.0
        return String(format: "%.1f m", meters)
    }
    
    // Convierte hectogramos a kilogramos formateados (ej. 60 -> 6.0 kg)
    var formattedWeight: String {
        let kilograms = Double(weight) / 10.0
        return String(format: "%.1f kg", kilograms)
    }
    
    var chartStats: [PokemonChartStat] {
        stats.map { slot in
            let cleanName: String
            switch slot.stat.name.lowercased() {
            case "hp": cleanName = "HP"
            case "attack": cleanName = "Atk"
            case "defense": cleanName = "Def"
            case "special-attack": cleanName = "Sp. Atk"
            case "special-defense": cleanName = "Sp. Def"
            case "speed": cleanName = "Speed"
            default: cleanName = slot.stat.name.capitalized
            }
            return PokemonChartStat(name: cleanName, value: slot.baseStat)
        }
    }
    
    // Calcula la suma total de puntos (Base Stat Total)
    var baseStatTotal: Int {
        stats.reduce(0) { $0 + $1.baseStat }
    }
}

extension PokemonDetail {
    static func createMock(id: Int, name: String) -> PokemonDetail {
        return PokemonDetail(
            id: id,
            name: name,
            height: 7,
            weight: 60,
            sprites: SpriteVersions(
                frontDefault: "https://fake.url",
                other: OtherSprites(officialArtwork: ArtworkPath(frontDefault: "https://fake.url")),
                versions: GenerationVersions(generationIx: GameVersions(scarletViolet: ScarletVioletPath(frontDefault: "https://fake.url")))
            ),
            types: [TypeElement(type: TypeInfo(name: "grass"))],
            abilities: [AbilitySlot(isHidden: false, ability: AbilityInfo(name: "overgrow"))],
            stats: [StatSlot(baseStat: 45, stat: StatInfo(name: "hp"))]
        )
    }
    
    static func createMockWithStats(stats: [StatSlot]) -> PokemonDetail {
        return PokemonDetail(
            id: 1, name: "test", height: 10, weight: 10,
            sprites: SpriteVersions(
                frontDefault: "https://fake.url",
                other: OtherSprites(officialArtwork: ArtworkPath(frontDefault: "https://fake.url")),
                versions: GenerationVersions(generationIx: GameVersions(scarletViolet: ScarletVioletPath(frontDefault: "https://fake.url")))
            ),
            types: [], abilities: [], stats: stats
        )
    }
    
    static func createMockWithDimensions(height: Int, weight: Int) -> PokemonDetail {
        return PokemonDetail(
            id: 1, name: "test", height: height, weight: weight,
            sprites: SpriteVersions(
                frontDefault: "https://fake.url",
                other: OtherSprites(officialArtwork: ArtworkPath(frontDefault: "https://fake.url")),
                versions: GenerationVersions(generationIx: GameVersions(scarletViolet: ScarletVioletPath(frontDefault: "https://fake.url")))
            ),
            types: [], abilities: [], stats: []
        )
    }
}
