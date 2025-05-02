//
//  ChatsView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import SwiftUI

struct ChatsView: View {
    @StateObject var viewModel = ChatsViewModel()
    
    var body: some View {
        VStack {
            Text("all chats")
                .bold()
                .font(.system(size: 30))
                .frame(maxWidth: .infinity, alignment: .topLeading)
            ScrollView {
                if let chats = viewModel.myChats {
                    
                    ForEach(chats, id: \.username) { chat in
                        HStack {
                            Button {
                                viewModel.selectedUser = chat.username
                                viewModel.isPresented.toggle()
                            } label: {
                                PersonIconView(nickname: chat.username, size: 45)
                            }
                            
                            VStack {
                                Text("\(chat.username)")
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 1)
                                
//                                if chat.lastMessage != nil {
//                                    Text("\(chat.usernameSent ?? "You "):")
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .padding(.bottom, 0)
//                                        .font(.system(size: 15))
//                                }
                                
                                Text("\(chat.lastMessage ?? "no messages yet")")
                                    .font(.system(size: 15))
                                    .opacity(0.6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            VStack {
                                if chat.timeSent != nil {
                                    Text("\(chat.timeSent!.getMessageDateString())")
                                        .font(.system(size: 15))
                                        .opacity(0.5)
                                }
                                Spacer()
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .padding(.leading, 45)
                        
                    }
                }
            }
        }.padding(.horizontal, 15)
            .padding(.top, 15)
            .task {
                do {
                    try await viewModel.getPeopleList()
                }catch {
                    
                }
            }
            .sheet(isPresented: $viewModel.isPresented) {
                PersonSheet(dependency: .init(username: viewModel.selectedUser, onTerminate: {action in }))
            }
            .onAppear {
                viewModel.getMyChats()
            }
    }
}
