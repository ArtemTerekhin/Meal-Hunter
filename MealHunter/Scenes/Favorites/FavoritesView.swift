//
//  FavoritesView.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading favorites...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.meals.isEmpty {
                    Text("No favorite meals yet.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.meals) { meal in
                        NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                            HStack {
                                if let url = meal.thumbnail {
                                    RemoteImageView(url: url, width: 60, height: 60, cornerRadius: 8)
                                        .frame(width: 60, height: 60)
                                }

                                Text(meal.name)
                                    .font(.headline)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .task {
                viewModel.setContext(modelContext)
                await viewModel.loadFavoriteMeals()
            }
        }
    }
}
