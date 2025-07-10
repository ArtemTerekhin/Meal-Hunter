//
//  SearchViewModel.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var meals: [MealSummary] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var randomMealId: String?

    private var cachedMeals: [MealSummary] = []

    func loadInitialMeals() async {
        await loadMeals(from: .searchByFirstLetter("b"), cache: true)
    }

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            meals = cachedMeals
            return
        }

        await loadMeals(from: .searchByIngredient(trimmed))
    }

    private func loadMeals(from endpoint: APIEndpoint, cache: Bool = false) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: MealSummaryResponse = try await APIService.shared.request(endpoint)
            meals = response.meals ?? []
            if cache {
                cachedMeals = meals
            }
        } catch {
            errorMessage = error.localizedDescription
            meals = []
        }

        isLoading = false
    }

    func loadRandomMeal() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: MealDetailResponse = try await APIService.shared.request(.randomMeal)
            if let meal = response.meals.first {
                randomMealId = meal.idMeal
            } else {
                errorMessage = "No meal found."
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
