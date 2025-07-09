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
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else if viewModel.meals.isEmpty && !viewModel.query.isEmpty {
                    Spacer()
                    Text("No meals found.")
                        .foregroundColor(.gray)
                    Spacer()
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
