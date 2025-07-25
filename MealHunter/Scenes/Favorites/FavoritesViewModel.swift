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

    private var favoritesManager: any FavoritesManagerProtocol
    private let apiService: APIServiceProtocol

    init(
        environment: AppEnvironment
    ) {
        self.favoritesManager = environment.favoritesManager
        self.apiService = environment.apiService
    }

    func setContext(_ context: ModelContext) {
        favoritesManager.setContext(context)
    }

    func loadFavoriteMeals() async {
        isLoading = true
        errorMessage = nil
        meals = []

        let ids = favoritesManager.favorites.map { $0.id }
        do {
            let mealDetails = try await withThrowingTaskGroup(of: MealDetail?.self) { group in
                for id in ids {
                    group.addTask {
                        let response: MealDetailResponse = try await self.apiService.request(.mealDetail(id))
                        return response.meals.first.map { MealDetail(from: $0) }
                    }
                }
                var results: [MealDetail] = []
                for try await meal in group {
                    if let meal = meal {
                        results.append(meal)
                    }
                }
                return results
            }
            meals = mealDetails
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
