//
//  ContentView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MainViewModel()
    var storageService = StorageService()
    var body: some View {
        VStack {
            if viewModel.isLogedIn {
                MapView()
            } else {
                SignUpView(isLoged: $viewModel.isLogedIn)
            }
        }
        .onAppear {
            storageService.deleteUser()
            
            viewModel.checkLogedIn()
        }
    }
}

#Preview {
    ContentView()
}
