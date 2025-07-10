//
//  APIMeal.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import Foundation

struct APIMeal: Decodable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String?
    let strMealThumb: String?
    let strYoutube: String?

    let ingredientsList: [Ingredient]

    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strInstructions
        case strMealThumb
        case strYoutube
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)

        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)

        var tempIngredients: [Ingredient] = []

        for index in 1...20 {
            guard
                let ingredientKey = DynamicCodingKey(stringValue: "strIngredient\(index)"),
                let measureKey = DynamicCodingKey(stringValue: "strMeasure\(index)")
            else {
                continue
            }

            let ingredient = (try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey) ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let measure = (try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey) ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            if !ingredient.isEmpty {
                tempIngredients.append(Ingredient(name: ingredient, measure: measure))
            }
        }

        ingredientsList = tempIngredients
    }
}

struct DynamicCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }

    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
}

