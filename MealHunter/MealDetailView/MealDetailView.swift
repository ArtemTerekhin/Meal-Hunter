//
//  MealDetailView.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject private var viewModel: MealDetailViewModel

    init(mealID: String) {
        _viewModel = StateObject(wrappedValue: MealDetailViewModel(mealID: mealID))
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error)
            } else if let meal = viewModel.meal {
                VStack(alignment: .leading, spacing: 16) {
                    if let url = meal.thumbnail {
                        RemoteImageView(url: meal.thumbnail, height: 240, cornerRadius: 0)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ingredients")
                            .font(.headline)
                        ForEach(meal.ingredients) { ingredient in
                            Text("• \(ingredient.name) — \(ingredient.measure)")
                                .font(.body)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Instructions")
                            .font(.headline)
                        Text(meal.instructions)
                            .font(.body)
                    }
                    .padding(.horizontal)

                    if let youtubeURL = meal.youtubeURL {
                        Link(destination: youtubeURL) {
                            Label("Watch on YouTube", systemImage: "play.circle.fill")
                                .font(.headline)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top)
            }
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMeal()
        }
        .alert("Error", isPresented: $viewModel.showAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        })

    }
}
