//
//  FavoritesTests.swift
//  MealHunterTests
//
//  Created by Artem Terekhin on 25.07.2025.
//

import Foundation
import Testing
@testable import MealHunter

struct FavoritesViewModelTests {
    @Test
    func testLoadFavoriteMeals_success() async throws {
        let mockAPI = MockAPIService()
        mockAPI.mealsToReturn = [
            APIMeal(idMeal: "1", strMeal: "Pizza", ingredientsList: []),
            APIMeal(idMeal: "2", strMeal: "Burger", ingredientsList: [])
        ]

        let mockFavorites = MockFavoritesManager()
        mockFavorites.favorites = [
            FavoriteMeal(id: "1"),
            FavoriteMeal(id: "2")
        ]

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: mockFavorites
        )

        let viewModel = await FavoritesViewModel(environment: environment)

        await viewModel.loadFavoriteMeals()

        await #expect(viewModel.meals.count == 2)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.meals.map(\.name).contains("Pizza"))
    }

    @Test
    func testLoadFavoriteMeals_failure() async throws {
        let mockAPI = MockAPIService()
        mockAPI.shouldReturnError = true

        let mockFavorites = MockFavoritesManager()
        mockFavorites.favorites = [FavoriteMeal(id: "1")]

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: mockFavorites
        )

        let viewModel = await FavoritesViewModel(environment: environment)

        await viewModel.loadFavoriteMeals()

        await #expect(viewModel.meals.isEmpty)
        await #expect(viewModel.errorMessage != nil)
        await #expect(viewModel.isLoading == false)
    }

    @Test
    func testLoadFavoriteMeals_emptyFavorites() async throws {
        let mockAPI = MockAPIService()
        let mockFavorites = MockFavoritesManager()
        mockFavorites.favorites = []

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: mockFavorites
        )

        let viewModel = await FavoritesViewModel(environment: environment)

        await viewModel.loadFavoriteMeals()

        await #expect(viewModel.meals.isEmpty)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.isLoading == false)
    }
}
