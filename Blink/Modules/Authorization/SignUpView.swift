//
//  SignUpView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel: AuthViewModel
    
    init(isLogedIn: Binding<Bool>) {
        _viewModel = .init(wrappedValue: .init(isLogedIn: isLogedIn))
    }
    
    var body: some View {
        LinearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea(.all)
            .scaledToFill()
            .overlay {
                VStack(spacing: 30) {
                    Text("Авторизация")
                        .font(.largeTitle)
                        .bold()
                        .font(.system(size: 26))
                        .padding(.bottom, 30)
                        .foregroundStyle(Color .black)

                    TextField("", text: $viewModel.username, prompt: Text("Логин")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.gray)
                    )
                        .font(.system(size: 18, weight: .medium))
                        .padding(.leading, 10)
                        .frame(width: 300, height: 50)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 22)
                                .foregroundStyle(.black)
                        }
                    
                    VStack {
                        SecureField("", text: $viewModel.password, prompt: Text("Пароль")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.gray)
                        )
                        .font(.system(size: 18, weight: .medium))
                        .padding(.leading, 10)
                        .frame(width: 300, height: 50)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 22)
                                .foregroundStyle(.black)
                        }
                        if viewModel.errorState.errorType != nil {
                            Text(viewModel.errorState.errorType == nil ? "" : viewModel.errorState.errorType!.returnErrorMessage())
                                .foregroundColor(.red)
                                .font(.system(size: 15, weight: .medium))
                                .transition(.opacity .combined(with: .scale))
                                .padding(.top, 10)
                        }
                    }.animation(.spring, value: viewModel.errorState.errorType)
                    
                    Button {
                      guard viewModel.checkAllFieldsAreFilled() else { return }
                        Task {
                            let isLogedIn = await viewModel.authefication(activity: .authorization)
                            await MainActor.run {
                                withAnimation {
                                    viewModel.isLogedIn = isLogedIn
                                }
                            }
                        }
                    } label: {
                        Text("Войти")
                            .background(
                                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                                    .fill(.black)
                                    .frame(width: 200, height: 50)
                            )
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                    }
                    
                    Button {
                        guard viewModel.checkAllFieldsAreFilled() else { return }
                        Task {
                            let isLogedIn = await viewModel.authefication(activity: .registration)
                            await MainActor.run {
                                withAnimation {
                                    viewModel.isLogedIn = isLogedIn
                                }
                            }
                        }
                    } label: {
                        Text("Зарегистроваться")
                            .background(
                                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                                    .fill(.black)
                                    .frame(width: 200, height: 50)
                            )
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                    }

                    Spacer()
                }
                .padding(.top, 150)
            }.onChange(of: "\(viewModel.username)\(viewModel.password)") { newValue in
                viewModel.errorState.clearError()
            }
    }
}

