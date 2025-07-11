//
//  APIService.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import Foundation

protocol APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class APIService: APIServiceProtocol {
    static let shared = APIService()
    private init() {}

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
                throw APIError.invalidResponse
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

final class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var mealsToReturn: [APIMeal] = []

    func request<T>(_ endpoint: APIEndpoint) async throws -> T where T : Decodable {
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
