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
    private let environment = AppEnvironment.live

    var body: some Scene {
        WindowGroup {
            MainTabView(environment: environment)
                .modelContainer(for: [FavoriteMeal.self])
        }
    }
}
