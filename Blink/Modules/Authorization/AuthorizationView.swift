//
//  AuthorizationView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import SwiftUI

struct AuthorizationView: View {
    @StateObject var viewModel : ViewModel = .init()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                TextField("Username", text: $viewModel.username)
                TextField("Password", text: $viewModel.password)
                Button {
                    Task {
                        try await viewModel.login()
                    }
                } label: {
                    Text("Авторизоватся")
                }.disabled(viewModel.isLoading)
            }
        }
    }
}

#Preview {
    AuthorizationView()
}
