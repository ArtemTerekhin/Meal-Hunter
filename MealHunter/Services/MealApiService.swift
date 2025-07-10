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
        let response: MealDetailResponse = try await APIService.shared.request(.mealDetail(id))

        guard let apiMeal = response.meals.first else {
            throw APIError.mealNotFound
        }

        return MealDetail(from: apiMeal)
    }
}

struct MealDetailResponse: Decodable {
    let meals: [APIMeal]
}
