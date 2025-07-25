//
//  MealDetailView.swift
//  MealHunter
//
//  Created by Artem Terekhin on 07.07.2025.
//

import SwiftUI
import SwiftData

struct MealDetailView: View {
    @StateObject private var viewModel: MealDetailViewModel
    @Environment(\.modelContext) private var modelContext

    init(mealID: String, environment: AppEnvironment) {
        _viewModel = StateObject(
            wrappedValue: MealDetailViewModel(
                mealID: mealID,
                environment: environment
            )
        )
    }

    var body: some View {
        ScrollView {
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error)
                } else if let meal = viewModel.meal {
                    content(for: meal)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.setContext(modelContext)
            await viewModel.loadMeal()
        }
        .alert("Error", isPresented: $viewModel.showAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        })
    }

    @ViewBuilder
    private func content(for meal: MealDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if let url = meal.thumbnail {
                RemoteImageView(url: url, height: 240, cornerRadius: 0)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(meal.name)
                        .font(.largeTitle)

                    Spacer()

                    Button(
                        action: {
                            viewModel.toggleFavorite()
                        }, label: {
                            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 22))
                                .foregroundColor(.yellow)
                                .padding(8)
                                .background(Color.yellow.opacity(0.2))
                                .clipShape(Circle())
                        }
                    )
                    .buttonStyle(.plain)
                }

                Text("Ingredients")
                    .font(.headline)

                ForEach(meal.ingredients) { ingredient in
                    HStack(alignment: .top) {
                        Text("•")
                        Text("\(ingredient.name) – \(ingredient.measure)")
                    }
                    .font(.body)
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                Text("Instructions")
                    .font(.headline)

                Text(meal.instructions)
                    .font(.body)
            }
            .padding(.horizontal)

            if let youtubeURL = meal.youtubeURL {
                Link(destination: youtubeURL) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Watch on YouTube")
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
    }
}
