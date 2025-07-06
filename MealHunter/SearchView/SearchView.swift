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
                HStack {
                    TextField("Enter ingredient", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)

                    Button("Search") {
                        Task {
                            await viewModel.search()
                        }
                    }
                    .disabled(viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

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
                } else if viewModel.meals.isEmpty {
                    Spacer()
                    Text("No meals found.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(viewModel.meals) { meal in
                        NavigationLink(destination: Text("Meal Detail Coming Soon")) {
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
        }
    }
}
