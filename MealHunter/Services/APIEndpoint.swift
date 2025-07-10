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
    case randomMeal
    case searchByFirstLetter(String)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.themealdb.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }

    private var path: String {
        switch self {
        case .searchByIngredient:
            return "/api/json/v1/1/filter.php"
        case .mealDetail:
            return "/api/json/v1/1/lookup.php"
        case .randomMeal:
            return "/api/json/v1/1/random.php"
        case .searchByFirstLetter:
            return "/api/json/v1/1/search.php"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .searchByIngredient(let ingredient):
            return [URLQueryItem(name: "i", value: ingredient)]

        case .mealDetail(let id):
            return [URLQueryItem(name: "i", value: id)]

        case .randomMeal:
            return nil

        case .searchByFirstLetter(let letter):
            return [URLQueryItem(name: "f", value: letter)]
        }
    }
}
