//
//  MessagesView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.05.25.
//

import SwiftUI

struct MessagesView: View {
    @StateObject var viewModel: MessagesViewModel
    
    init(dependency: MessagesDependency) {
        _viewModel = .init(wrappedValue: .init(
            dependency: dependency
        ))
    }
    
    var body: some View {
        VStack {
            Button {
                viewModel.isUserPagePresented.toggle()
            } label: {
                HStack {
                    PersonIconView(nickname: viewModel.chatWithUsername, size: 50, fontSize: 35)
                    
                    Text("\(viewModel.chatWithUsername)")
                        .bold()
                        .font(.system(size: 25))
                        .padding(.bottom, 5)
                        .foregroundStyle(Color.black)
                }
            }
            
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
                    
                    messagesList
                        .padding(.bottom, 8)
                    
                    
                    messageTextField
                    
                }
                .transition(.opacity)
                .padding(.horizontal, 7)
                .sheet(isPresented: $viewModel.isUserPagePresented) {
                    PersonSheet(dependency: .init(username: viewModel.chatWithUsername, onTerminate: {action in }, networkManager: viewModel.model.networkManager))
                }
            }
            Spacer()
        }
        .onAppear {
            viewModel.getChatMessages()
        }
        .padding(.top, 15)
        .animation(.easeInOut(duration: 0.5), value: viewModel.viewState)
    }
    
    var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                ForEach(Array((viewModel.messages ?? []).enumerated()), id: \.element) { index, message in
                    VStack {
                        if viewModel.messageSet.contains(message.id) {
                            
                            Text(message.time.getRuDateString())
                                .padding(.vertical, 5)
                                .padding(.horizontal, 15)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(Color.gray)
                                        .opacity(0.15)
                                }
                                .padding(.vertical, 10)
                        }
                        
                        HStack(spacing: 7) {
                            Text(message.text.insertLineBreaks(every: 20))
                                .padding(.leading, 10)
                            VStack {
                                Spacer()
                                
                                HStack(spacing: 2) {
                                    Text(message.time.getHourAndMinutes())
                                        .font(.system(size: 10))
                                    
                                    isReadMessageView(message: message)
                                }
                                .padding(.trailing, 3)
                                .opacity(0.5)
                            }
                            
                            
                        }.padding(.all, 5)
                        
                            .background {
                                ChatBubbleShape(cornerRadius: message.text.count / 20 == 0 ? 17 : 15)
                                    .foregroundStyle(Color.green)
                                    .opacity(0.7)
                                    .scaleEffect(
                                        x: message.usernameTo == viewModel.myUsername ? -1 : 1,
                                        y: 1,
                                        anchor: .center
                                    )
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: message.usernameTo == viewModel.myUsername ? .leading : .trailing
                            )
                            .id(message.id)
                            .padding(.horizontal, 8)
                    }
                    
                }.animation(.easeIn, value: viewModel.messages)
                    .padding(.bottom, 7)
            }
            .onAppear {
                viewModel.readMessages()
                viewModel.getSetOfMessagesWithDate()
            }
            .defaultScrollAnchor(.bottom)
            .onChange(of: viewModel.messages?.last?.id) { id in
                viewModel.readMessages()
                viewModel.getSetOfMessagesWithDate()
                if let id = id {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
            }
        }
        
    }
    
    func isReadMessageView(message: Message) -> some View {
        HStack {
            if message.usernameTo != viewModel.myUsername {
                if !message.isRead {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .medium))
                } else {
                    ZStack {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .medium))
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .medium))
                            .offset(x: 3)
                    }
                }
            }
        }
    }
    
    func datePlaceholder(index: Int, message: Message?) -> some View {
        VStack {
            if index > 0 {
                if (viewModel.messages?[index - 1].time.getDistanceBetweenDates(to: message!.time))! > 0 {
                    Text(message!.time.getRuDateString())
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color.gray)
                                .opacity(0.7)
                        }
                }
            } else {
                Text(message!.time.getRuDateString())
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.gray)
                            .opacity(0.7)
                    }
            }
        }
    }
    
    var messageTextField: some View {
        HStack {
            TextField("", text: $viewModel.messageText, prompt: Text("Сообщение")
                .foregroundStyle(Color.primary.opacity(0.5))
            )
            .autocorrectionDisabled(true)
            .padding(.leading, 10)
            .background {
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color(red: 199/255, green: 208/255, blue: 204/255))
                    .stroke(.green, lineWidth: 1.5)
                    .frame(height: 45)
            }
            .onChange(of: viewModel.messageText) { oldValue, newValue in
                if !newValue.isEmpty {
                    withAnimation {
                        viewModel.isPresentedSendButton = true
                    }
                } else {
                    withAnimation {
                        viewModel.isPresentedSendButton = false
                    }
                }
            }
            
            if viewModel.isPresentedSendButton {
                Button {
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "arrowshape.up.circle.fill")
                        .foregroundStyle(Color.blue)
                        .font(.system(size: 35))
                        .padding(0)
                }
            }
        }
        .ignoresSafeArea(.all)
        .padding(.bottom, 25)
        .padding(.top, 3)
    }
}

