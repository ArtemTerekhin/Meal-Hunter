//
//  SearchView.swift
//  MealHunter
//
//  Created by Artem Terekhin on 06.07.2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                content
            }
            .task {
                if viewModel.query.isEmpty {
                    await viewModel.loadInitialMeals()
                } else {
                    await viewModel.search()
                }
            }
            .navigationTitle("Meal Hunter")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.loadRandomMeal()
                        }
                    } label: {
                        Label("Random Meal", systemImage: "die.face.5.fill")
                    }
                }
            }
            .searchable(text: $viewModel.query, prompt: "Enter ingredient")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
            .navigationDestination(isPresented: Binding<Bool>(
                get: { viewModel.randomMealId != nil },
                set: { if !$0 { viewModel.randomMealId = nil } }
            )) {
                if let id = viewModel.randomMealId {
                    MealDetailView(mealID: id)
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error)
        } else if viewModel.meals.isEmpty {
            EmptyViewState(message: "No meals found.")
        } else {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.id)) {
                    HStack {
                        RemoteImageView(url: meal.thumbnailURL, width: 60, height: 60)
                        Text(meal.name)
                            .font(.headline)
                            .padding(.leading, 8)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}
