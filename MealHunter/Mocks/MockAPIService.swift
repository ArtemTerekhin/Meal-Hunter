//
//  MockAPIService.swift
//  MealHunter
//
//  Created by Artem Terekhin on 25.07.2025.
//

final class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var mealsToReturn: [APIMeal] = []

    func request<T>(_ endpoint: APIEndpoint) async throws -> T where T: Decodable {
        if shouldReturnError {
            throw APIError.invalidResponse
        }

        if T.self == MealDetailResponse.self {
            let response = MealDetailResponse(meals: mealsToReturn)
            return response as! T
        }

        fatalError("Unsupported request type")
    }
}
