//
//  MainTabBar.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import SwiftUI

struct MainTabView: View {
    let environment: AppEnvironment

    enum Tab: Int {
        case favorites = 0
        case search = 1
    }

    @State private var selectedTab: Tab = .search

    var body: some View {
        TabView(selection: $selectedTab) {
            FavoritesView(environment: environment)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(Tab.favorites)

            SearchView(environment: environment)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Search")
                }
                .tag(Tab.search)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Main Tab View")
    }
}
