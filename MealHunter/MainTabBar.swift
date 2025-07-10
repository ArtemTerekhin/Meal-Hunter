//
//  MainTabBar.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(0)

            SearchView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Search")
                }
                .tag(1)
        }
    }
}
