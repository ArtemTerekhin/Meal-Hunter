//
//  MockFavoritesManager.swift
//  MealHunter
//
//  Created by Artem Terekhin on 25.07.2025.
//

import Foundation
import SwiftData

final class MockFavoritesManager: FavoritesManagerProtocol {
    @Published var favorites: [FavoriteMeal] = []

    func setContext(_ context: ModelContext) {
        // noop
    }

    func fetchFavorites() {
        // noop
    }

    func isFavorite(id: String) -> Bool {
        favorites.contains { $0.id == id }
    }

    func add(id: String) {
        if !favorites.contains(where: { $0.id == id }) {
            favorites.append(FavoriteMeal(id: id))
        }
    }

    func remove(id: String) {
        favorites.removeAll { $0.id == id }
    }
}
