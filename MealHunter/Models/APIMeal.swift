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

    struct IngredientMeasure {
        let ingredient: String
        let measure: String
    }

    let ingredients: [IngredientMeasure]

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb, strYoutube
    }

    struct DynamicKeys: CodingKey {
        var stringValue: String
        var intValue: Int? { nil }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)

        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)

        var tempIngredients: [IngredientMeasure] = []

        for i in 1...20 {
            let ingredientKey = DynamicKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicKeys(stringValue: "strMeasure\(i)")!

            if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey),
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                tempIngredients.append(IngredientMeasure(ingredient: ingredient, measure: measure))
            }
        }

        ingredients = tempIngredients
    }
}
