//
//  UserPageView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 26.04.25.
//

import SwiftUI
import CoreLocation

struct PersonSheet: View {
    @StateObject private var viewModel : UserPageViewModel
    
    init(
        dependency: UserPageDependency
    ) {
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
                ZStack {
                    Circles()
                        .frame(alignment: .topLeading)
                        .offset(x: -150, y: -350)
                    
                }.overlay {
                    VStack {
                        
                        userInfo(username: viewModel.userInfo?.username)
                        
                        Text("📍 \(viewModel.region ?? "")")
                            .offset(y: -40)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 100)
                        
                        if viewModel.userInfo?.username != viewModel.myUsername {
                            HStack {
                                if viewModel.userInfo?.status == .friend {
                                    actionButton(
                                        imagePath: "ellipsis.message.fill",
                                        buttonText: "Сообщения") {
                                            viewModel.isShowingMessages.toggle()
                                        }
                                    
                                }
                                
                                switch viewModel.userInfo?.status {
                                case .friend:
                                    actionButton(imagePath: "delete.left.fill", buttonText: "Удалить") {
                                        viewModel.changeStatus(status: .unknown)
                                        viewModel.userInfo?.status = .unknown
                                    }.transition(.opacity)
                                case .request:
                                    HStack {
                                        actionButton(imagePath: "plus.rectangle.fill", buttonText: "Добавить") {
                                            viewModel.changeStatus(status: .friend)
                                            viewModel.userInfo?.status = .friend
                                        }.transition(.opacity)
                                        
                                        actionButton(imagePath: "delete.left.fill", buttonText: "Удалить запрос") {
                                            viewModel.changeStatus(status: .unknown)
                                            viewModel.userInfo?.status = .unknown
                                        }.transition(.opacity)
                                    }
                                case .myRequest:
                                    actionButton(imagePath: "delete.left.fill", buttonText: "Отменить запрос") {
                                        viewModel.changeStatus(status: .unknown)
                                        viewModel.userInfo?.status = .unknown
                                    }.transition(.opacity)
                                case .unknown:
                                    actionButton(imagePath: "plus.rectangle.fill", buttonText: "Отправить запрос") {
                                        viewModel.changeStatus(status: .request)
                                        viewModel.userInfo?.status = .myRequest
                                    }.transition(.opacity)
                                default:
                                    EmptyView()
                                }
                            }
                            .animation(.easeInOut, value: viewModel.userInfo?.status)
                            .padding(.bottom, 40)
                        }
                        
                        HStack(spacing: 70) {
                            friendImages(friendAmount: viewModel.userInfo?.friendAmount)
                                .offset(x: -50)
                            rectangeView
                        }
                        
                        heartAnimation
                            .padding(.top, 70)
                        if viewModel.userInfo?.status == .friend {
                            Text("дружите с \(viewModel.userInfo?.friendsSince!.getRuDateString() ?? "").")
                                .padding(.top, 30)
                                .foregroundStyle(.gray)
                            Text("\(viewModel.userInfo?.friendsSince!.getDistanceBetweenDates(to: Date.now) ?? 0) дней провели вместе 😉")
                                .foregroundStyle(.gray)
                        } else {
                            Text(viewModel.userInfo?.username != viewModel.myUsername ? "Все еще не друзья." : "Это Вы!")
                                .padding(.top, 30)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 30)
                }
                .sheet(isPresented: $viewModel.isShowingMessages) {
                    MessagesView(dependency: .init(username: viewModel.userInfo?.username ?? "", networkManager: viewModel.model.networkManager))
                }
                .transition(.opacity)
            }
        }.task {
            await viewModel.launch()
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.viewState)
    }
    
    func actionButton(imagePath: String, buttonText: String, completion: @escaping () -> Void) -> some View {
        Button(action: completion) {
            HStack(spacing: 10) {
                Image(systemName: imagePath)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundStyle(.yellow)
                
                Text(buttonText)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundStyle(.yellow)
            }
            .frame(width: 170, height: 45)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue)
                    .opacity(0.7)
            }
        }
    }
    
    func userInfo(username: String?) -> some View {
        ZStack {
            PersonIconView(nickname: username ?? "1", size: 120, fontSize: 55)
            
            Text("@\(username ?? "")")
                .font(.system(size: 19))
                .bold()
                .padding(5)
                .background(RoundedRectangle(cornerSize: CGSize(width: 9, height: 9))
                    .fill(Color("base-color")))
                .rotationEffect(Angle(degrees: -10))
                .offset(x: 0, y: 60)
        }
    }
    
    func friendImages(friendAmount: Int?) -> some View {
        ZStack {
            friendWithCircle(imageUrl: "man")
            friendWithCircle(imageUrl: "woman")
                .offset(x: 30)
            friendWithCircle(imageUrl: "boy")
                .offset(x: 60)
            Text("\(friendAmount ?? 0)")
                .foregroundStyle(Color .white)
                .shadow(color: .black, radius: 0, x: 2, y: 2)
                .font(.system(size: 35))
                .bold()
                .rotationEffect(Angle(degrees: -7))
                .offset(x: -10, y: -30)
            Text("friends")
                .rotationEffect(.degrees(4))
                .foregroundStyle(Color .white)
                .shadow(color: .black, radius: 0, x: 2, y: 2)
                .offset(x: 35, y: 40)
                .bold()
                .font(.system(size: 28))
        }
    }
    
    func friendWithCircle(imageUrl: String) -> some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 2.5)
                .frame(width: 50, height: 50)
                .background {
                    Image(imageUrl)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
        }
    }
    
    var heartAnimation: some View {
        Image(systemName: "heart")
            .font(.system(size: 60))
            .foregroundStyle(.black)
            .symbolEffect(.breathe)
    }
    
    var rectangeView: some View {
        RoundedRectangle(cornerSize: CGSize(width: 24, height: 24))
            .frame(width: 105, height: 105)
            .foregroundStyle(.linearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            .rotationEffect(.degrees(-8))
            .overlay {
                eyeAnimation
                    .offset(x: -10, y: -36)
                Text("\(viewModel.userInfo?.peopleVisited ?? 0)")
                    .rotationEffect(.degrees(-9))
                    .bold()
                    .foregroundStyle(Color .white)
                    .font(.system(size: 33))
                    .shadow(color: .black, radius: 0, x: 2, y: 2)
                    .offset(y: 20)
            }
            .offset(x: 15)
        
    }
    
    var eyeAnimation: some View {
        Image(systemName: "eyes")
            .font(.system(size: 50))
            .foregroundStyle(Color(red: 0, green: 207/255, blue: 1))
            .symbolEffect(.wiggle.clockwise.byLayer, options: .repeating)
    }
    
    var showOnMapButton: some View {
        Button(
            action: { viewModel.handle(viewAction: .closeAndZoomOnUser) },
            label: { Text("show on map") }
        )
    }
}

struct Circles: View {
    @State private var animate = false
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.indigo, lineWidth: 20)
                .fill(Color .pink)
                .frame(width: 200, height: 200)
                .blur(radius: 40)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
            
            Circle()
                .stroke(Color.blue, lineWidth: 60)
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)
            
            Circle()
                .stroke(Color.red, lineWidth: 80)
                .frame(width: animate ? 360 : 600, height: animate ? 360 : 600)
                .blur(radius: 60)
                .offset(x: animate ? 30 : 0, y: animate ? 20 : -10)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animate)
            
            
            Circle()
                .stroke(animate ? Color.orange : Color.yellow, lineWidth: 130)
                .frame(width: 500, height: 500)
                .blur(radius: 60)
                .offset(x: animate ? 100 : 60, y: animate ? 200 : 20)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animate)
        }
        .onAppear() {
            animate = true
        }
    }
}

