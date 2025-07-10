//
//  ViewStates.swift
//  MealHunter
//
//  Created by Artem Terekhin on 10.07.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

struct EmptyViewState: View {
    let message: String

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
