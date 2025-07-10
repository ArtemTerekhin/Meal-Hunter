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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var randomMealId: String?
    @Published var initialMeals: [MealSummary] = []

    func loadInitialMeals() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: MealSummaryResponse = try await APIService.shared.request(.searchByFirstLetter("b"))
            initialMeals = response.meals ?? []
            meals = initialMeals
        } catch {
            errorMessage = error.localizedDescription
            initialMeals = []
            meals = []
        }

        isLoading = false
    }

    func search() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            meals = initialMeals
            return
        }
        isLoading = true
        errorMessage = nil

        let endpoint = APIEndpoint.searchByIngredient(query)

        do {
            let response: MealSummaryResponse = try await APIService.shared.request(endpoint)
            meals = response.meals ?? []
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
