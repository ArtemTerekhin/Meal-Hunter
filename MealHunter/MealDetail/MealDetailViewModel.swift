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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert = false

    private var favoritesManager = FavoritesManager.shared
    private let service: MealAPIServiceProtocol
    private let mealID: String

    init(
        mealID: String,
        service: MealAPIServiceProtocol = MealAPIService(),
        favoritesManager: FavoritesManager = .shared
    ) {
        self.mealID = mealID
        self.service = service
        self.favoritesManager = favoritesManager
    }

    func loadMeal() async {
        isLoading = true
        errorMessage = nil

        do {
            let detail = try await service.fetchMealDetail(id: mealID)
            self.meal = detail
        } catch {
            self.errorMessage = error.localizedDescription
            showAlert = true
        }

        isLoading = false
    }

    func toggleFavorite() {
        guard let meal = meal else { return }

        if favoritesManager.isFavorite(id: meal.id) {
            favoritesManager.remove(id: meal.id)
        } else {
            favoritesManager.add(id: meal.id)
        }
    }
}
