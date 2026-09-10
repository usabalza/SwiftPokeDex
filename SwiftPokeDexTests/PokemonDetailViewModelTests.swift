//
//  PokemonDetailViewModelTests.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 21/8/26.
//

import Testing
import Foundation
@testable import SwiftPokeDex

@Suite("Pruebas del Detalle de Pokémon (ViewModel)")
struct PokemonDetailViewModelTests {
    
    // 🟩 TEST 1: Carga Exitosa de la Línea Evolutiva
    @Test("Al solicitar la cadena evolutiva con éxito, el ViewModel debe almacenar los eslabones ordenados")
    @MainActor
    func loadEvolutionChainSuccess() async {
        // Given
        let mockService = MockNetworkService()
        let samplePokemon = PokemonDetail.createMock(id: 4, name: "charmander")
        let sut = PokemonDetailViewModel(pokemon: samplePokemon, services: mockService)
        
        // Simulamos la respuesta de la línea evolutiva (Charmander -> Charmeleon)
        mockService.mockEvolutionLine = [
            EvolutionLink(id: 4, name: "charmander", imageURL: "https://fake.url"),
            EvolutionLink(id: 5, name: "charmeleon", imageURL: "https://fake.url")
        ]
        mockService.shouldReturnError = false
        
        // When
        await sut.getEvolutionLine()
        
        // Then
        #expect(sut.evolutionArray.count == 2)
        #expect(sut.evolutionArray.first?.name == "charmander")
        #expect(sut.evolutionArray.last?.id == 5)
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
    
    // 🟥 TEST 2: Manejo de Errores de Red
    @Test("Si falla la consulta de la evolución, el ViewModel debe capturar el mensaje de error")
    @MainActor
    func loadEvolutionChainFailure() async {
        // Given
        let mockService = MockNetworkService()
        let samplePokemon = PokemonDetail.createMock(id: 25, name: "pikachu")
        let sut = PokemonDetailViewModel(pokemon: samplePokemon, services: mockService)
        
        mockService.shouldReturnError = true
        
        // When
        await sut.getEvolutionLine()
        
        // Then
        #expect(sut.evolutionArray.isEmpty)
        #expect(sut.errorMessage != nil)
        #expect(sut.isLoading == false)
    }
    
    // 🚫 TEST 3: Evitar Peticiones Redundantes (Optimización de Memoria)
    @Test("Si la línea evolutiva ya fue cargada, llamadas subsecuentes no deben disparar nuevas peticiones")
    @MainActor
    func avoidDuplicateNetworkCalls() async {
        // Given
        let mockService = MockNetworkService()
        let samplePokemon = PokemonDetail.createMock(id: 1, name: "bulbasaur")
        let sut = PokemonDetailViewModel(pokemon: samplePokemon, services: mockService)
        
        mockService.mockEvolutionLine = [EvolutionLink(id: 1, name: "bulbasaur", imageURL: "")]
        mockService.shouldReturnError = false // Si intentara llamar a la red, fallaría e impondría un error
        
        await sut.getEvolutionLine()
        
        #expect(sut.evolutionArray.count == 1)
        #expect(sut.isLoading == false)
        
        mockService.shouldReturnError = true
        
        // When
        await sut.getEvolutionLine()
        
        // Then
        #expect(sut.evolutionArray.count == 1)
        #expect(sut.errorMessage == nil) // Permanece nil porque la compuerta 'guard' detuvo la ejecución
    }
}
