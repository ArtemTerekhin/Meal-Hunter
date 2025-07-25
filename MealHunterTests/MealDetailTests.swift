//
//  MealDetailTests.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import Foundation
import Testing
@testable import MealHunter

struct MealDetailViewModelTests {
    @Test
    func testLoadMealSuccess() async throws {
        let mockFavorites = MockFavoritesManager()
        let expectedMeal = MealDetail(
            id: "123",
            name: "Pizza",
            instructions: "Bake it",
            thumbnail: nil,
            youtubeURL: nil,
            ingredients: []
        )

        let mockMealAPI = MockMealAPIService()
        mockMealAPI.mockMeal = expectedMeal

        let environment = AppEnvironment(
            apiService: MockAPIService(),
            mealAPIService: mockMealAPI,
            favoritesManager: mockFavorites
        )

        let viewModel = await MealDetailViewModel(mealID: "123", environment: environment)
        await viewModel.loadMeal()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.meal?.name == "Pizza")
        await #expect(viewModel.isFavorite == false)
    }

    @Test
    func testLoadMealFailure() async throws {
        let mockFavorites = MockFavoritesManager()
        let mockMealAPI = MockMealAPIService()
        mockMealAPI.shouldFail = true

        let environment = AppEnvironment(
            apiService: MockAPIService(),
            mealAPIService: mockMealAPI,
            favoritesManager: mockFavorites
        )

        let viewModel = await MealDetailViewModel(mealID: "999", environment: environment)
        await viewModel.loadMeal()

        await #expect(viewModel.meal == nil)
        await #expect(viewModel.errorMessage != nil)
        await #expect(viewModel.showAlert == true)
        await #expect(viewModel.isLoading == false)
    }

    @Test
    func testToggleFavoriteAddsMeal() async throws {
        let mockFavorites = MockFavoritesManager()
        let meal = MealDetail(
            id: "321",
            name: "Burger",
            instructions: "Grill it",
            thumbnail: nil,
            youtubeURL: nil,
            ingredients: []
        )

        let environment = AppEnvironment(
            apiService: MockAPIService(),
            mealAPIService: MockMealAPIService(mockMeal: meal),
            favoritesManager: mockFavorites
        )

        let viewModel = await MealDetailViewModel(mealID: "321", environment: environment)
        await MainActor.run {
            viewModel.meal = meal
            viewModel.isFavorite = false
        }

        await MainActor.run {
            viewModel.toggleFavorite()
        }

        await #expect(mockFavorites.isFavorite(id: "321") == true)
        await #expect(viewModel.isFavorite == true)
    }

    @Test
    func testToggleFavoriteRemovesMeal() async throws {
        let mockFavorites = MockFavoritesManager()
        mockFavorites.add(id: "321")

        let meal = MealDetail(
            id: "321",
            name: "Burger",
            instructions: "Grill it",
            thumbnail: nil,
            youtubeURL: nil,
            ingredients: []
        )

        let environment = AppEnvironment(
            apiService: MockAPIService(),
            mealAPIService: MockMealAPIService(mockMeal: meal),
            favoritesManager: mockFavorites
        )

        let viewModel = await MealDetailViewModel(mealID: "321", environment: environment)
        await MainActor.run {
            viewModel.meal = meal
            viewModel.isFavorite = true
        }

        await MainActor.run {
            viewModel.toggleFavorite()
        }

        await #expect(mockFavorites.isFavorite(id: "321") == false)
        await #expect(viewModel.isFavorite == false)
    }
}

