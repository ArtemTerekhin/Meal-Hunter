//
//  MealSummary.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import Foundation

struct MealSummaryResponse: Decodable {
    let meals: [MealSummary]?
}

struct MealSummary: Identifiable, Decodable {
    let id: String
    let name: String
    let thumbnailURL: URL?

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}
