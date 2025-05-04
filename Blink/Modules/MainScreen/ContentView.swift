//
//  ContentView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        VStack {
            if viewModel.isLogedIn {
                MapView(isLogedIn: $viewModel.isLogedIn)
                    .transition(.slide)
                    .animation(.smooth, value: viewModel.isLogedIn)
            } else {
                SignUpView(isLogedIn: $viewModel.isLogedIn)
                    .transition(.slide)
                    .animation(.smooth, value: viewModel.isLogedIn)
            }
        }
        .onAppear {
            viewModel.checkLogedIn()
        }
    }
}

