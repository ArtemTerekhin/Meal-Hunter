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
                                AsyncImage(url: meal.thumbnailURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 60, height: 60)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    case .failure:
                                        Color.gray
                                            .frame(width: 60, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

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
