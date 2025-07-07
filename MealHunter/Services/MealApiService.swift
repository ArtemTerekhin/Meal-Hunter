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
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let result = try JSONDecoder().decode(MealDetailResponse.self, from: data)

        guard let apiMeal = result.meals.first else {
            throw NSError(domain: "MealDetailError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Meal not found"])
        }

        return MealDetail(from: apiMeal)
    }
}

private struct MealDetailResponse: Decodable {
    let meals: [APIMeal]
}
