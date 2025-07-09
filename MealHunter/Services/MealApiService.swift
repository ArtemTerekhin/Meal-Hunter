//
//  MealApiService.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import Foundation

protocol MealAPIServiceProtocol {
    func fetchMealDetail(id: String) async throws -> MealDetail
}

final class MealAPIService: MealAPIServiceProtocol {
    func fetchMealDetail(id: String) async throws -> MealDetail {
        let endpoint = APIEndpoint.mealDetail(id)
        let response: MealDetailResponse = try await APIService.shared.request(endpoint)

        guard let apiMeal = response.meals.first else {
            throw NSError(domain: "MealDetailError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Meal not found"])
        }

        return MealDetail(from: apiMeal)
    }
}

private struct MealDetailResponse: Decodable {
    let meals: [APIMeal]
}
