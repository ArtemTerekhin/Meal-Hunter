//
//  MealDetailViewModel.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import Foundation
import SwiftData

@MainActor
final class MealDetailViewModel: ObservableObject {
    @Published var meal: MealDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false
    @Published private(set) var isFavorite = false

    private var favoritesManager: FavoritesManagerProtocol
    private let service: MealAPIServiceProtocol
    private let mealID: String

    init(mealID: String, environment: AppEnvironment) {
        self.mealID = mealID
        self.service = environment.mealAPIService
        self.favoritesManager = environment.favoritesManager
    }

    func setContext(_ context: ModelContext) {
        favoritesManager.setContext(context)
    }

    func loadMeal() async {
        isLoading = true
        errorMessage = nil

        do {
            let detail = try await service.fetchMealDetail(id: mealID)
            self.meal = detail
            self.isFavorite = favoritesManager.isFavorite(id: detail.id)
        } catch {
            self.errorMessage = error.localizedDescription
            showAlert = true
        }

        isLoading = false
    }

    func toggleFavorite() {
        guard let meal else { return }

        if favoritesManager.isFavorite(id: meal.id) {
            favoritesManager.remove(id: meal.id)
            isFavorite = false
        } else {
            favoritesManager.add(id: meal.id)
            isFavorite = true
        }
    }
}
