//
//  APIEndpoint.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import Foundation

enum APIEndpoint {
    case searchByIngredient(String)
    case mealDetail(String)

    var url: URL {
        switch self {
        case .searchByIngredient(let ingredient):
            let encoded = ingredient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?i=\(encoded)")!
        case .mealDetail(let id):
            return URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!
        }
    }
}
