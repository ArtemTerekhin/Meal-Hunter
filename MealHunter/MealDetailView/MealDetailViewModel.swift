//
//  MealDetailViewModel.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import Foundation

@MainActor
final class MealDetailViewModel: ObservableObject {
    @Published var meal: MealDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAlert = false

    private let service: MealAPIServiceProtocol
    private let mealID: String

    init(mealID: String, service: MealAPIServiceProtocol = MealAPIService()) {
        self.mealID = mealID
        self.service = service
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
}
