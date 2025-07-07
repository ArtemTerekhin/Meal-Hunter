//
//  MealDetail.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import Foundation

struct MealDetail: Codable, Identifiable {
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

        var ingredients: [Ingredient] = []
        for i in 1...20 {
            if let name = apiMeal.value(forKey: "strIngredient\(i)") as? String,
               let measure = apiMeal.value(forKey: "strMeasure\(i)") as? String,
               !name.trimmingCharacters(in: .whitespaces).isEmpty {
                ingredients.append(Ingredient(name: name, measure: measure))
            }
        }
        self.ingredients = ingredients
    }
}
