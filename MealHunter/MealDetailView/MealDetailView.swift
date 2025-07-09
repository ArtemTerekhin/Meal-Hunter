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
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if let meal = viewModel.meal {
                VStack(alignment: .leading, spacing: 16) {
                    if let url = meal.thumbnail {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 240)
                                    .clipped()
                            case .failure:
                                Color.gray.frame(height: 240)
                            @unknown default:
                                EmptyView()
                            }
                        }
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
    }
}
