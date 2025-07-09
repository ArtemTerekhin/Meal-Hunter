//
//  APIError.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case decodingError(Error)
    case unknown
    case mealNotFound

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        case .mealNotFound:
            return "Meal not found."
        }
    }
}
