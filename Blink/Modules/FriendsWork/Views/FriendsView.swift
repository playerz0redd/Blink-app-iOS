//
//  FriendsView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation
import SwiftUI
import CoreLocation


struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel
    @FocusState private var isFocused: Bool
    @State private var isShowingBackground: Bool = false
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: String
    
    init(isShowingFriendInfoSheet: Binding<Bool>, selectedUser: Binding<String>, networkManager: NetworkManager) {
        self._isShowingFriendInfoSheet = isShowingFriendInfoSheet
        self._selectedUser = selectedUser
        _viewModel = .init(wrappedValue: .init(networkManager: networkManager))
    }
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView {
                    Text("Загрузка")
                        .font(.system(size: 23, weight: .medium))
                        .foregroundStyle(.black)
                }
                .padding(.top, 140)
                .transition(.opacity)
            case .error(let apiError):
                Text("\(apiError.returnErrorMessage())")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(.black)
                    .transition(.opacity)
                    .padding(.top, 140)
            case .success:
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewModel.usernameToRequest == "" ? "все друзья " : "люди найдены ")
                                .bold()
                                .font(.largeTitle)
                            +
                            Text("\(viewModel.peopleSearch.count)")
                                .foregroundStyle(Color .gray)
                                .bold()
                                .font(.system(size: 30))
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.leading, 10)
                    
                    FriendsSectionView(
                        viewModel: viewModel,
                        selectedUser: $selectedUser
                    ).transition(.opacity)
                    
                    Spacer()
                    
                    searchField
                    
                }.transition(.opacity)
            }
        }
        .refreshable {
            if viewModel.usernameToRequest == "" {
                viewModel.getPeopleList()
            } else {
                viewModel.findPeopleByUsername(username: viewModel.usernameToRequest)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.viewState)
        .onAppear {
            viewModel.friendStatus = .friend
            viewModel.getPeopleList()
        }
    }
    
    
    var searchField: some View {
        HStack(spacing: 5) {
            TextField("", text: $viewModel.usernameToRequest, prompt: Text("поиск").bold().font(.system(size: 25)))
                .bold()
                .font(.system(size: 20))
                .padding(.leading, 16)
                .padding(.bottom, 30)
                .focused($isFocused)
                .onChange(of: isFocused) { newValue in
                    withAnimation {
                        isShowingBackground = newValue
                    }
                }
                .onSubmit({
                    if viewModel.usernameToRequest != "" {
                        withAnimation {
                            viewModel.peopleSearch = []
                            viewModel.findPeopleByUsername(username: viewModel.usernameToRequest)
                        }
                    }
                })
                .background {
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.dark)
                            .opacity(0.45)
                            .frame(height: 50)
                            .padding(.bottom, 27)
                    }
                }
                .padding(.leading, 10)
            
            if isShowingBackground || viewModel.usernameToRequest != "" {
                Button {
                    withAnimation {
                        viewModel.usernameToRequest = ""
                    }
                    viewModel.friendStatus = .friend
                    viewModel.getPeopleList()
                    isFocused = false
                
                } label: {
                    Image(systemName: "xmark.app")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.black)
                        .transition(.opacity)
                        .padding(.bottom, 27)
                }

            }
        }
        .background {
            if isShowingBackground {
                LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing)
                    .cornerRadius(20)
                    .blur(radius: 30)
                    .transition(.opacity .combined(with: .scale))
                    .animation(.easeInOut(duration: 0.5), value: isShowingBackground)
            }
        }
        .padding(.trailing, 10)
    }
}
