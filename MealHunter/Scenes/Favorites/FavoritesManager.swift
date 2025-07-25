//
//  FavoritesManager.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import Foundation
import SwiftData

protocol FavoritesManagerProtocol: ObservableObject {
    var favorites: [FavoriteMeal] { get }
    func setContext(_ context: ModelContext)
    func fetchFavorites()
    func isFavorite(id: String) -> Bool
    func add(id: String)
    func remove(id: String)
}

final class FavoritesManager: ObservableObject, FavoritesManagerProtocol {
    static let shared = FavoritesManager()

    @Published private(set) var favorites: [FavoriteMeal] = []
    private var modelContext: ModelContext?

    private init() {}

    func setContext(_ context: ModelContext) {
        self.modelContext = context
        fetchFavorites()
    }

    func fetchFavorites() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<FavoriteMeal>()
        do {
            favorites = try context.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
        }
    }

    func isFavorite(id: String) -> Bool {
        favorites.contains { $0.id == id }
    }

    func add(id: String) {
        guard let context = modelContext, !isFavorite(id: id) else { return }
        context.insert(FavoriteMeal(id: id))
        save()
        fetchFavorites()
    }

    func remove(id: String) {
        guard let context = modelContext,
              let toRemove = favorites.first(where: { $0.id == id }) else { return }

        context.delete(toRemove)
        save()
        fetchFavorites()
    }

    private func save() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            print("Save failed: \(error)")
        }
    }
}
