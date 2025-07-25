//
//  AppContainer.swift
//  MealHunter
//
//  Created by Artem Terekhin on 25.07.2025.
//

import Foundation

struct AppEnvironment {
    let apiService: APIServiceProtocol
    let mealAPIService: MealAPIServiceProtocol
    let favoritesManager: FavoritesManagerProtocol

    static let live = AppEnvironment(
        apiService: APIService(),
        mealAPIService: MealAPIService(),
        favoritesManager: FavoritesManager.shared
    )

    static let mock = AppEnvironment(
        apiService: MockAPIService(),
        mealAPIService: MockMealAPIService(),
        favoritesManager: MockFavoritesManager()
    )
}
