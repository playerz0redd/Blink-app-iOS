//
//  SignUpView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import SwiftUI

struct SignUpView: View {
    @Binding var isLoged : Bool
    @StateObject var viewModel = ViewModel()
    var body: some View {
        Image("sign-up-image")
            .resizable()
            .ignoresSafeArea(.all)
            .scaledToFill()
            .overlay {
                VStack(spacing: 30) {
                    Text("Авторизация")
                        .font(.largeTitle)
                        .bold()
                        .font(.system(size: 26))
                        .padding(.bottom, 40)
                        .foregroundStyle(Color .red)

                    TextField("  Ваш логин", text: $viewModel.username)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                            .stroke(Color.gray, lineWidth: 1)
                            .fill(.indigo)
                            .opacity(0.94))

                    SecureField("  Ваш пароль", text: $viewModel.password)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8))
                            .stroke(Color.gray, lineWidth: 1)
                            .fill(.indigo)
                            .opacity(0.94))
                    
                    Button {
                        Task {
                            isLoged = try await viewModel.authefication(isLoged: isLoged, activity: .authorization)
                        }
                    } label: {
                        Text("Войти")
                            .background(
                                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                                    .fill(.yellow)
                                    .frame(width: 200, height: 50)
                            )
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.red)
                            .padding(.top, 60)
                    }
                    
                    Button {
                        Task {
                            isLoged = try await viewModel.authefication(isLoged: isLoged, activity: .registration)
                        }
                    } label: {
                        Text("Зарегистроваться")
                            .background(
                                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                                    .fill(.yellow)
                                    .frame(width: 200, height: 50)
                            )
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.red)
                            .padding(.top, 30)
                    }

                    Spacer()
                }
                .padding(.top, 130)
            }
    }
}

