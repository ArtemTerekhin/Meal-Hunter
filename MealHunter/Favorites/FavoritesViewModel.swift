//
//  FavoritesViewModel.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import Foundation
import SwiftData

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var meals: [MealDetail] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var favoritesManager: FavoritesManager = FavoritesManager()

    func setContext(_ context: ModelContext) {
        favoritesManager.setContext(context)
    }

    func loadFavoriteMeals() async {
        isLoading = true
        errorMessage = nil
        meals = []

        do {
            let ids = favoritesManager.favorites.map { $0.id }

            for id in ids {
                let response: MealDetailResponse = try await APIService.shared.request(.mealDetail(id))
                if let apiMeal = response.meals.first {
                    let meal = MealDetail(from: apiMeal)
                    meals.append(meal)
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
