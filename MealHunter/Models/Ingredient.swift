//
//  Ingredient.swift
//  MealHunter
//
//  Created by Artem Terekhin on 09.07.2025.
//

import Foundation

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let measure: String
}
