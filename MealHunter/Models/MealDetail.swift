//
//  MealDetail.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import Foundation

struct MealDetail: Identifiable {
    let id: String
    let name: String
    let instructions: String
    let thumbnail: URL?
    let youtubeURL: URL?
    let ingredients: [Ingredient]

    struct Ingredient: Identifiable {
        let id = UUID()
        let name: String
        let measure: String
    }

    init(from apiMeal: APIMeal) {
        self.id = apiMeal.idMeal
        self.name = apiMeal.strMeal
        self.instructions = apiMeal.strInstructions ?? ""
        self.thumbnail = URL(string: apiMeal.strMealThumb ?? "")
        self.youtubeURL = URL(string: apiMeal.strYoutube ?? "")

        self.ingredients = apiMeal.ingredients.map {
            Ingredient(name: $0.ingredient, measure: $0.measure)
        }
    }
}
