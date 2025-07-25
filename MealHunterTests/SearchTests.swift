//
//  SearchTests.swift
//  MealHunterTests
//
//  Created by Artem Terekhin on 11.07.2025.
//

import Foundation
import Testing
@testable import MealHunter

struct SearchViewModelTests {
    @Test
    func testLoadInitialMealsSccess() async throws {
        let mockAPI = MockSearchAPIService()
        mockAPI.mealsToReturn = [
            MealSummary(id: "1", name: "Pizza", thumbnailURL: URL(string: "https://example.com/1.jpg")),
            MealSummary(id: "2", name: "Burger", thumbnailURL: URL(string: "https://example.com/2.jpg"))
        ]
        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: MockFavoritesManager()
        )

        let viewModel = await SearchViewModel(environment: environment)

        await viewModel.loadInitialMeals()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.meals.count == 2)
        await #expect(viewModel.meals.first?.name == "Pizza")
    }

    @Test
    func testSearchSuccess() async throws {
        let mockAPI = MockSearchAPIService()
        mockAPI.mealsToReturn = [
            MealSummary(id: "3", name: "Pasta", thumbnailURL: URL(string: "https://example.com/3.jpg"))
        ]
        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: MockFavoritesManager()
        )

        let viewModel = await SearchViewModel(query: "Pasta", environment: environment)

        await viewModel.search()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.meals.count == 1)
        await #expect(viewModel.meals.first?.name == "Pasta")
    }

    @Test
    func testSearchEmptyQueryReturnsCache() async throws {
        let mockAPI = MockSearchAPIService()
        mockAPI.mealsToReturn = [
            MealSummary(id: "4", name: "Taco", thumbnailURL: nil)
        ]

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: MockFavoritesManager()
        )

        let viewModel = await SearchViewModel(environment: environment)

        await viewModel.loadInitialMeals()

        await MainActor.run {
            viewModel.query = ""
        }

        await viewModel.search()

        await #expect(viewModel.meals.first?.name == "Taco")
    }

    @Test
    func testSearchFailure() async throws {
        let mockAPI = MockSearchAPIService()
        mockAPI.shouldFail = true

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: MockFavoritesManager()
        )

        let viewModel = await SearchViewModel(query: "Soup", environment: environment)

        await viewModel.search()

        await #expect(viewModel.errorMessage != nil)
        await #expect(viewModel.meals.isEmpty)
    }

    @Test
    func testLoadRandomMealSuccess() async throws {
        let mockAPI = MockSearchAPIService()
        mockAPI.detailToReturn = APIMeal(idMeal: "7", strMeal: "Ramen", ingredientsList: [])

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: MockFavoritesManager()
        )

        let viewModel = await SearchViewModel(environment: environment)

        await viewModel.loadRandomMeal()

        await #expect(viewModel.randomMealId == "7")
        await #expect(viewModel.errorMessage == nil)
    }

    @Test
    func testLoadRandomMealFailure() async throws {
        let mockAPI = MockSearchAPIService()
        mockAPI.shouldFail = true

        let environment = AppEnvironment(
            apiService: mockAPI,
            mealAPIService: MockMealAPIService(),
            favoritesManager: MockFavoritesManager()
        )

        let viewModel = await SearchViewModel(environment: environment)

        await viewModel.loadRandomMeal()

        await #expect(viewModel.errorMessage != nil)
        await #expect(viewModel.randomMealId == nil)
    }
}
