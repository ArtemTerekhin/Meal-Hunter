//
//  MockSearchAPIService.swift
//  MealHunter
//
//  Created by Artem Terekhin on 25.07.2025.
//

import Foundation

final class MockSearchAPIService: APIServiceProtocol {
    var mealsToReturn: [MealSummary] = []
    var detailToReturn: APIMeal?
    var shouldFail = false

    func request<T>(_ endpoint: APIEndpoint) async throws -> T where T : Decodable {
        if shouldFail {
            throw APIError.invalidResponse
        }

        switch endpoint {
        case .searchByFirstLetter, .searchByIngredient:
            let response = MealSummaryResponse(meals: mealsToReturn)
            return response as! T

        case .randomMeal:
            let response = MealDetailResponse(meals: detailToReturn.map { [$0] } ?? [])
            return response as! T

        default:
            fatalError("Unsupported endpoint for mock")
        }
    }
}
