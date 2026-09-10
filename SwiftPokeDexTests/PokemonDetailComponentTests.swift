//
//  PokemonDetailTests.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 21/8/26.
//


import Testing
import Foundation
@testable import SwiftPokeDex

@Suite("Pruebas de la Pantalla de Detalle (Modelos y Lógica)")
struct PokemonDetailComponentTests {
    
    // 📊 TEST 1: Validación de Transformación para SwiftCharts
    @Test("chartStats debe transformar los nombres técnicos de la API a abreviaciones de videojuegos")
    func chartStatsTransformation() {
        // Given: Creamos un Pokémon con las estadísticas crudas de la PokeAPI
        let rawStats = [
            StatSlot(baseStat: 45, stat: StatInfo(name: "hp")),
            StatSlot(baseStat: 49, stat: StatInfo(name: "attack")),
            StatSlot(baseStat: 65, stat: StatInfo(name: "special-attack"))
        ]
        
        let pokemon = PokemonDetail.createMockWithStats(stats: rawStats)
        
        // When: Accedemos a la propiedad computada que alimenta a SwiftCharts
        let chartData = pokemon.chartStats
        
        // Then: Verificamos que se mapearon correctamente las abreviaciones y los valores
        #expect(chartData.count == 3)
        #expect(chartData[0].name == "HP")
        #expect(chartData[0].value == 45)
        #expect(chartData[1].name == "Atk")
        #expect(chartData[2].name == "Sp. Atk")
        #expect(chartData[2].value == 65)
    }
    
    // 🔢 TEST 2: Validación del Cálculo de Base Stat Total (BST)
    @Test("baseStatTotal debe calcular correctamente la suma de todas las estadísticas base")
    func baseStatTotalCalculation() {
        // Given
        let rawStats = [
            StatSlot(baseStat: 100, stat: StatInfo(name: "hp")),
            StatSlot(baseStat: 100, stat: StatInfo(name: "attack")),
            StatSlot(baseStat: 100, stat: StatInfo(name: "defense"))
        ]
        let pokemon = PokemonDetail.createMockWithStats(stats: rawStats)
        
        // When
        let total = pokemon.baseStatTotal
        
        // Then
        #expect(total == 300)
    }
    
    // 📏 TEST 3: Validación de Conversión de Unidades Físicas (Peso y Altura)
    @Test("formattedHeight y formattedWeight deben convertir decímetros y hectogramos a metros y kilogramos con un decimal")
    func physicalUnitsFormatting() {
        // Given: Un Pokémon con altura = 7 (7 decímetros) y peso = 69 (69 hectogramos)
        let pokemon = PokemonDetail.createMockWithDimensions(height: 7, weight: 69)
        
        // When & Then
        #expect(pokemon.formattedHeight == "0.7 m")
        #expect(pokemon.formattedWeight == "6.9 kg")
    }
}
