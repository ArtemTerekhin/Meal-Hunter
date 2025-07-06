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

    func search() async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil

        let endpoint = APIEndpoint.searchByIngredient(query)

        do {
            let response = try await APIService.shared.fetch(MealSummaryResponse.self, from: endpoint.url)
            meals = response.meals ?? []
        } catch {
            errorMessage = error.localizedDescription
            meals = []
        }

        isLoading = false
    }
}
