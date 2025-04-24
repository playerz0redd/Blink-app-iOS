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
    let friendViewModel = FriendsViewModel()
    var body: some View {
        VStack {
            if viewModel.isLogedIn {
                MapView()
            } else {
                SignUpView(isLoged: $viewModel.isLogedIn)
            }
        }
        .onAppear {
            //storageService.deleteUser()
            Task {
                try await friendViewModel.getPeopleList()
            }
            print(friendViewModel.$peopleSearch)
            viewModel.checkLogedIn()
        }
    }
}

#Preview {
    ContentView()
}
