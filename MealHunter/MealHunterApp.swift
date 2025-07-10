//
//  MealHunterApp.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import SwiftUI
import SwiftData

@main
struct MealHunterApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: [FavoriteMeal.self])
        }
    }
}
