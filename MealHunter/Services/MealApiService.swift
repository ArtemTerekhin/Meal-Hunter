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

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        let result = try JSONDecoder().decode(MealDetailResponse.self, from: data)

        guard let apiMeal = result.meals.first else {
            throw APIError.mealNotFound
        }

        return MealDetail(from: apiMeal)
    }
}

struct MealDetailResponse: Decodable {
    let meals: [APIMeal]
}
