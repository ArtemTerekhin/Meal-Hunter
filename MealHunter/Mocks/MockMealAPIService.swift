//
//  MockMealAPIService.swift
//  MealHunter
//
//  Created by Artem Terekhin on 25.07.2025.
//

import Foundation

final class MockMealAPIService: MealAPIServiceProtocol {
    var mockMeal: MealDetail?
    var shouldFail = false

    func fetchMealDetail(id: String) async throws -> MealDetail {
        if shouldFail {
            throw APIError.invalidResponse
        }
        if let meal = mockMeal {
            return meal
        }
        throw APIError.mealNotFound
    }
}
