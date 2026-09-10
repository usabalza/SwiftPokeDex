//
//  PokemonListViewModelTests.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 21/8/26.
//


import Testing
import Foundation
@testable import SwiftPokeDex

// Las suites en Swift Testing se agrupan en structs comunes, no requieren clases.
@Suite("Pruebas del Listado de Pokémon (ViewModel)")
struct PokemonListViewModelTests {
    
    // Test 1: Verificar escenario exitoso
    @Test("Al cargar la página con éxito, se deben añadir los Pokémon al listado")
    @MainActor
    func loadPokemonPageSuccess() async {
        // Given (Dado que...) Inicializamos el Mock y el ViewModel localmente
        let mockNetworkService = MockNetworkService()
        let sut = PokemonListViewModel(services: mockNetworkService)
        
        let pokemon1 = PokemonDetail.createMock(id: 1, name: "bulbasaur")
        let pokemon2 = PokemonDetail.createMock(id: 4, name: "charmander")
        
        mockNetworkService.mockPokemonDetails = [pokemon1, pokemon2]
        mockNetworkService.shouldReturnError = false
        
        // When (Cuando...) Ejecutamos la carga
        await sut.loadPokemonPage()
        
        // Then (Entonces...) Validamos usando las nuevas macros #expect
        #expect(sut.pokemonList.count == 2)
        #expect(sut.pokemonList.first?.name == "bulbasaur")
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }
    
    // Test 2: Verificar escenario de error de red
    @Test("Si la red falla, la lista debe quedar vacía y capturar el mensaje de error")
    @MainActor
    func loadPokemonPageFailure() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let sut = PokemonListViewModel(services: mockNetworkService)
        mockNetworkService.shouldReturnError = true
        
        // When
        await sut.loadPokemonPage()
        
        // Then
        #expect(sut.pokemonList.isEmpty)
        #expect(sut.errorMessage != nil) // Evaluamos que contenga un string de error
        #expect(sut.isLoading == false)
    }
    
    // 🔍 TEST 3: Búsqueda por Texto (Test Parametrizado)
    // El framework ejecutará esta función 3 veces, una por cada caso de la lista 'arguments'
    @Test("El buscador debe filtrar correctamente por coincidencia de nombre o id", arguments: [
        (searchText: "bulba", expectedCount: 1, expectedFirstName: "bulbasaur"),
        (searchText: "004", expectedCount: 1, expectedFirstName: "charmander"),
        (searchText: "inexistente", expectedCount: 0, expectedFirstName: nil)
    ])
    @MainActor
    func searchFiltering(searchText: String, expectedCount: Int, expectedFirstName: String?) async {
        // Given
        let mockService = MockNetworkService()
        let sut = PokemonListViewModel(services: mockService)
        
        // Alimentamos el listado inicial
        sut.pokemonList = [
            PokemonDetail.createMock(id: 1, name: "bulbasaur"),
            PokemonDetail.createMock(id: 4, name: "charmander")
        ]
        
        // When: Modificamos el texto de búsqueda
        sut.searchText = searchText
        
        // Then: Evaluamos la propiedad computada pasándole un arreglo de favoritos vacío
        let result = sut.filteredPokemon(favoriteIds: [])
        
        #expect(result.count == expectedCount)
        if let expectedFirstName {
            #expect(result.first?.name == expectedFirstName)
        }
    }
    
    // ❤️ TEST 4: Filtrado por la pestaña de Favoritos
    @Test("Al activar el tag de favoritos, sólo deben retornar los Pokémon guardados localmente")
    @MainActor
    func favoritesTagFiltering() async {
        // Given
        let mockService = MockNetworkService()
        let sut = PokemonListViewModel(services: mockService)
        
        sut.pokemonList = [
            PokemonDetail.createMock(id: 1, name: "bulbasaur"),
            PokemonDetail.createMock(id: 4, name: "charmander"),
            PokemonDetail.createMock(id: 7, name: "squirtle")
        ]
        
        // Simulamos que el usuario tiene guardados en SwiftData a Bulbasaur (1) y Squirtle (7)
        let mockFavoriteIds = [1, 7]
        
        // When: Cambiamos el tag seleccionado a Favoritos
        sut.selectedTag = .favorites
        
        // Then: Evaluamos la lista pasándole los IDs guardados
        let result = sut.filteredPokemon(favoriteIds: mockFavoriteIds)
        
        #expect(result.count == 2)
        #expect(result.contains(where: { $0.name == "bulbasaur" }))
        #expect(result.contains(where: { $0.name == "squirtle" }))
        #expect(!result.contains(where: { $0.name == "charmander" })) // Charmander no debe estar
    }
    
    // 🔀 TEST 5: Combinación de Favoritos + Buscador
    @Test("Al estar en la pestaña de favoritos, el buscador sólo debe filtrar dentro de los favoritos")
    @MainActor
    func searchInsideFavorites() async {
        // Given
        let mockService = MockNetworkService()
        let sut = PokemonListViewModel(services: mockService)
        
        sut.pokemonList = [
            PokemonDetail.createMock(id: 1, name: "bulbasaur"),
            PokemonDetail.createMock(id: 4, name: "charmander")
        ]
        let mockFavoriteIds = [1] // Sólo Bulbasaur es favorito
        
        // Activamos el filtro de favoritos y buscamos algo que coincide con un Pokémon NO favorito (Charmander)
        sut.selectedTag = .favorites
        sut.searchText = "char"
        
        // When
        let result = sut.filteredPokemon(favoriteIds: mockFavoriteIds)
        
        // Then: El resultado debe ser 0 porque aunque Charmander coincide con el texto, NO es favorito
        #expect(result.isEmpty)
    }
}
