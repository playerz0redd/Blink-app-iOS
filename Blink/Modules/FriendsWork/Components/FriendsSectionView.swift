//
//  FriendsSectionView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import SwiftUI
import CoreLocation

struct FriendsSectionView: View {
    @StateObject var viewModel: FriendsViewModel
    var isPresented = false
    @Binding var selectedUser: String
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.peopleSearch, id: \.self.username) { friend in
                    HStack(spacing: 15) {
                        Button {
                            viewModel.selectedUser = friend.username
                            viewModel.isPresented.toggle()
                        } label: {
                            PersonIconView(nickname: friend.username, size: 35)
                            
                            Text("\(friend.username)")
                                .bold()
                                .foregroundStyle(Color.black)
                            
                            Spacer()
                        }
                        
                        switch friend.status {
                        case .friend:
                            HStack(spacing: 27) {
                                Text("друзья")
                                    .bold()
                                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                                
                                FriendsActionButton(
                                    leftColor: .purple,
                                    rightColor: .pink,
                                    imagePath: "captions.bubble.fill") {
                                        viewModel.selectedUser = friend.username
                                        viewModel.isPresentedMessages.toggle()
                                    }
                            }
                        case .request:
                            HStack(spacing: 27) {
                                FriendsActionButton(
                                    leftColor: .blue,
                                    rightColor: .purple,
                                    imagePath: "person.crop.circle.badge.checkmark") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .friend,
                                            with: friend.username,
                                            action: .updateItem
                                        )
                                    }
                                
                                FriendsActionButton(
                                    leftColor: .purple,
                                    rightColor: .pink,
                                    imagePath: "person.crop.circle.badge.xmark") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .unknown,
                                            with: friend.username,
                                            action: .deleteItem
                                        )
                                    }
                            }
                            
                        case .block:
                            Text("заблокирован")
                                .bold()
                        case .myRequest:
                            HStack(spacing: 27) {
                                Text("запрос")
                                    .bold()
                                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                                
                                FriendsActionButton(
                                    leftColor: .purple,
                                    rightColor: .pink,
                                    imagePath: "person.crop.circle.badge.xmark") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .unknown,
                                            with: friend.username,
                                            action: .deleteItem
                                        )
                                    }
                            }
                        case .unknown:
                            FriendsActionButton(
                                leftColor: .purple,
                                rightColor: .pink,
                                imagePath: "person.fill.badge.plus") {
                                    viewModel.buttonChangeStatus(
                                        newStatus: .myRequest,
                                        with: friend.username,
                                        action: .updateItem
                                    )
                                }
                        }
                        
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.peopleSearch)
                    .padding(.horizontal, 15)
                }
                
                if viewModel.peopleSearch == [] {
                    Text("никто не найден...")
                        .font(.title)
                        .bold()
                        .padding(.top, 70)
                }
            }
            .sheet(isPresented: $viewModel.isPresented, onDismiss: {
                if viewModel.usernameToRequest == "" {
                    viewModel.getPeopleList()
                } else {
                    viewModel.findPeopleByUsername(username: viewModel.usernameToRequest)
                }
            }, content: {
                PersonSheet(dependency: .init(username: viewModel.selectedUser, onTerminate: {action in }, networkManager: viewModel.model.networkManager))
            })
            .sheet(isPresented: $viewModel.isPresentedMessages) {
                MessagesView(dependency: .init(username: viewModel.selectedUser, networkManager: viewModel.model.networkManager))
            }
        }
    }
}
