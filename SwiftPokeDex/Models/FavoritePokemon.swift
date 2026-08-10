//
//  FavoritePokemon.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 10/8/26.
//

import Foundation
import SwiftData

@Model
final class FavoritePokemon {
    @Attribute(.unique) var id: Int // Evita duplicados automáticos
    var name: String
    var type: String
    var imageURL: String
    var createdAt: Date // Para poder ordenar tus favoritos por fecha de guardado
    
    init(id: Int, name: String, type: String, imageURL: String) {
        self.id = id
        self.name = name
        self.type = type
        self.imageURL = imageURL
        self.createdAt = Date()
    }
}
