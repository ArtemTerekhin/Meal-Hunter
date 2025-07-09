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
            .navigationTitle("Meal Hunter")
            .searchable(text: $viewModel.query, prompt: "Enter ingredient")
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
        }
    }
}
