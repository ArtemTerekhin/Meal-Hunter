//
//  FavoriteMeal.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import SwiftData

@Model
final class FavoriteMeal {
    @Attribute(.unique) var id: String

    init(id: String) {
        self.id = id
    }
}
