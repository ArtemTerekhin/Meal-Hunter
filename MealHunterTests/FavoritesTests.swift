//
//  FavoritesTests.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import Foundation
import Testing
@testable import MealHunter

struct FavoritesTests {
    @Test
    func testLoadFavoriteMeals_Success() async throws {
        let mockAPI = MockAPIService()
        let mockFavoritesManager = await MockFavoritesManager()

        await MainActor.run {
            mockFavoritesManager.favorites = [
                FavoriteMeal(id: "1"),
                FavoriteMeal(id: "2")
            ]
        }

        let viewModel = await FavoritesViewModel(
            favoritesManager: mockFavoritesManager,
            apiService: mockAPI
        )

        mockAPI.mealsToReturn = [
            APIMeal(idMeal: "1", strMeal: "Meal 1", ingredientsList: []),
            APIMeal(idMeal: "2", strMeal: "Meal 2", ingredientsList: [])
        ]

        await viewModel.loadFavoriteMeals()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.meals.count == 2)
    }

    @Test
    func testLoadFavoriteMeals_Failure() async throws {
        let mockAPI = MockAPIService()
        let mockFavoritesManager = await MockFavoritesManager()

        await MainActor.run {
            mockFavoritesManager.favorites = [
                FavoriteMeal(id: "1")
            ]
        }

        let viewModel = await FavoritesViewModel(
            favoritesManager: mockFavoritesManager,
            apiService: mockAPI
        )

        mockAPI.shouldReturnError = true

        await viewModel.loadFavoriteMeals()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage != nil)
        await #expect(viewModel.meals.isEmpty == true)
    }
}
