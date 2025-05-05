//
//  ChatsView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import SwiftUI

struct ChatsView: View {
    @StateObject var viewModel: ChatsViewModel
    
    init(dependency: ChatDependency) {
        _viewModel = .init(wrappedValue: .init(
            dependency: dependency
        ))
    }
    
    var body: some View {
        VStack {
            Text("all chats")
                .bold()
                .font(.system(size: 30))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            ScrollView {
                if let chats = viewModel.myChats, !chats.isEmpty {
                    
                    ForEach(chats, id: \.username) { chat in
                        HStack {
                            Button {
                                viewModel.selectedUser = chat.username
                                viewModel.isPresented.toggle()
                            } label: {
                                PersonIconView(nickname: chat.username, size: 45)
                            }
                            Button {
                                viewModel.selectedUser = chat.username
                                viewModel.isPresentedChat.toggle()
                            } label: {
                                HStack {
                                    VStack {
                                        Text("\(chat.username)")
                                            .bold()
                                            .foregroundStyle(Color.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.bottom, 1)
                                        
                                        //                                if chat.lastMessage != nil {
                                        //                                    Text("\(chat.usernameSent ?? "You "):")
                                        //                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        //                                        .padding(.bottom, 0)
                                        //                                        .font(.system(size: 15))
                                        //                                }
                                        
                                        Text("\(chat.lastMessage ?? "no messages yet")")
                                            .foregroundStyle(Color.black)
                                            .font(.system(size: 15))
                                            .opacity(0.6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        if chat.timeSent != nil {
                                            Text("\(chat.timeSent!.getMessageDateString())")
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 15))
                                                .opacity(0.5)
                                        }
                                        Spacer()
                                    }
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }

                        Divider()
                            .padding(.leading, 45)
                        
                    }
                } else {
                    Text("Chats not found")
                        .font(.system(size: 30, weight: .medium))
                        .padding(.top, 200)
                }
            }
        }.padding(.horizontal, 15)
            .padding(.top, 15)
            .task {
                viewModel.getPeopleList()
            }
            .sheet(isPresented: $viewModel.isPresented) {
                viewModel.getMyChats()
            } content: {
                PersonSheet(dependency: .init(username: viewModel.selectedUser, onTerminate: {action in }, networkManager: viewModel.model.networkManager))
            }
            .onAppear {
                viewModel.getMyChats()
            }
            .sheet(isPresented: $viewModel.isPresentedChat) {
                viewModel.getMyChats()
            } content: {
                MessagesView(dependency: .init(username: viewModel.selectedUser, networkManager: viewModel.model.networkManager))
            }

    }
}
