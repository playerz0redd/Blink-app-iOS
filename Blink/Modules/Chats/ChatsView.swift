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
            switch viewModel.viewState {
            case .loading:
                ProgressView {
                    Text("Загрузка")
                        .font(.system(size: 23, weight: .medium))
                        .foregroundStyle(.black)
                }
                .transition(.opacity)
            case .error(let apiError):
                Text("\(apiError.returnErrorMessage())")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(.black)
                    .transition(.opacity)
            case .success:
                VStack {
                    Text("все чаты")
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
                                                
                                                Text("\(chat.lastMessage ?? "сообщений еще нет...")")
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
                                                if chat.amountOfUnread != 0 {
                                                    Text("\(chat.amountOfUnread)")
                                                        .padding(.horizontal, 10)
                                                        .padding(.vertical, 5)
                                                        .foregroundStyle(.white)
                                                        .font(.system(size: 15, weight: .medium))
                                                        .background {
                                                            Capsule()
                                                                .foregroundStyle(.blue)
                                                        }
                                                }
                                            }
                                            
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }.transition(.opacity)
                                
                                Divider()
                                    .padding(.leading, 45)
                                
                            }
                        } else {
                            Text("Чаты не найдены")
                                .font(.system(size: 30, weight: .medium))
                                .padding(.top, 200)
                        }
                    }
                    .refreshable {
                        viewModel.getMyChats()
                    }
                    .animation(.easeInOut, value: viewModel.myChats)
                }
                .padding(.horizontal, 15)
                .padding(.top, 15)
                .sheet(isPresented: $viewModel.isPresented) {
                    viewModel.getMyChats()
                } content: {
                    PersonSheet(dependency: .init(username: viewModel.selectedUser, onTerminate: {action in }, networkManager: viewModel.model.networkManager))
                }
                .sheet(isPresented: $viewModel.isPresentedChat) {
                    viewModel.getMyChats()
                } content: {
                    MessagesView(dependency: .init(username: viewModel.selectedUser, networkManager: viewModel.model.networkManager))
                }
                .transition(.opacity)
            }
        }
        .task {
            viewModel.getPeopleList()
        }
        .onAppear {
            viewModel.getMyChats()
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.viewState)
    }
}
