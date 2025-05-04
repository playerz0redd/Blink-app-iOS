//
//  View.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel: MapViewModel
    
    init(isLogedIn: Binding<Bool>) {
        self._viewModel = .init(wrappedValue: .init(model: .init(networkManager: NetworkManager2()), isLogedIn: isLogedIn))
    }
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region,
            interactionModes: [.all],
            showsUserLocation: true,
            annotationItems: viewModel.friendsLocation
        ) { friend in
            MapAnnotation(coordinate: friend.location) {
                PersonIconView(nickname: friend.username, size: 40)
                    .onTapGesture {
                        viewModel.selectFriend(friend)
                        withAnimation {
                            viewModel.region = .init(center: friend.location, span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03))
                        }
                        Task {
                            //try await viewModel.getPeopleAmount()
                            await viewModel.getRegion()
                            viewModel.isShowingSheet.toggle()
                            withAnimation {
                                viewModel.showBackground.toggle()
                            }
                        }
                    }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            Task {
                await viewModel.getPlace()
                try await viewModel.getFriendsLocation()
                try await viewModel.connectLocationSocket()
            }
            viewModel.updateSteps()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.bouncy(duration: 0.6), {
                    viewModel.showBackground = false
                })
            }
            do {
                try viewModel.locationManager.checkLocationServicesIsEnabled()
            } catch {
                print("+++")
            }
        }
        .mapControls({
            MapUserLocationButton()
        })
        .overlay(alignment: .topTrailing, content: {
            
            VStack(spacing: 21) {
                
                profileButton
                settingButton
                
            }
            .padding(.top, 65)
            .padding(.trailing, 12)

        })
        .mapStyle(viewModel.mapStyle)
        .sheet(isPresented: $viewModel.isShowingSheet, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    viewModel.showBackground = false
                }
            }
        }) {
            if let username = viewModel.selectedFriend?.username {
                PersonSheet(dependency: .init(
                    username: username,
                    onTerminate: { action in
                        switch action {
                        case .updateMapTarget(let coordinates):
                            viewModel.region = MKCoordinateRegion(
                                center: coordinates,
                                span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        case .none:
                            break
                        }
                        viewModel.isShowingSheet = false
                    }
                ))
            }
        }
        .sheet(isPresented: $viewModel.isPresentedFriendsSheet , onDismiss: {
            Task {
                try await viewModel.getFriendsLocation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    viewModel.showBackground = false
                }
            }
        }) {
            
            CustomTabView(isShowingFriendInfoSheet: $viewModel.isShowingSheet, selectedUser: $viewModel.name)
        }
        .sheet(isPresented: $viewModel.isPresentedChats , onDismiss: {
            Task {
                try await viewModel.getFriendsLocation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    viewModel.showBackground = false
                }
            }
        }) {
            ChatsView(dependency: .init(networkManager: viewModel.model.networkManager))
        }
        .sheet(isPresented: $viewModel.isPresentedSettings , onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    viewModel.showBackground = false
                }
            }
        }) {
            SettingsView(dependency: .init(mapStyle: $viewModel.mapStyle, isLogedIn: $viewModel.isLogedIn, isShowingSettings: $viewModel.isPresentedSettings, currentStyleIndex: $viewModel.currentStyleIndex))
                .presentationDetents([.medium])
        }
        .overlay(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                VStack {
                    Text("\(viewModel.place)")
                        .bold()
                        .frame(alignment: .topLeading)
                        .font(.system(size: 29))
                        .padding(.leading, 20)
                        .padding(.top, 25)
                        .underline()
                        .onReceive(viewModel.$region) { newRegion in
                            Task {
                                await viewModel.getPlace()
                            }
                        }
                }
            }
        }
        .overlay(alignment: .bottom, content: {
            HStack(spacing: 45) {
                Button {
                    viewModel.isPresentedFriendsSheet.toggle()
                    withAnimation {
                        viewModel.showBackground.toggle()
                    }
                } label: {
                    MapButtonView(
                        imageName: "person.2.fill",
                        imageSize: 27,
                        rectangleWidth: 65,
                        rectangleHeight: 75
                    )
                }
                
                Button {
                    viewModel.isPresentedChats.toggle()
                    withAnimation {
                        viewModel.showBackground.toggle()
                    }
                } label: {
                    MapButtonView(
                        imageName: "bubble.left.and.text.bubble.right.fill",
                        imageSize: 35,
                        rectangleWidth: 75,
                        rectangleHeight: 85
                    )
                }
                // this button is for step records 
                Button {
                    viewModel.isPresentedChats.toggle()
                } label: {
                    Image("sneaker-image")
                        .resizable()
                        .frame(width: 40, height: 40)// 35 for center, 27
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 65, height: 75) // 70,85 for center, 60,75
                                .foregroundStyle(Color("dark"))
                                .opacity(0.7)
                        }
                }

            }.padding(.bottom, 20)
        })
        .overlay {
            if viewModel.showBackground {
                LinearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.5)
                    .ignoresSafeArea(.all)
                    .transition(.opacity)
            }
        }
    }
    
    var profileButton: some View {
        Button {
            viewModel.selectedFriend = .init(username: viewModel.myUsername ?? "", location: viewModel.myLocation ?? .init())
            viewModel.isShowingSheet.toggle()
            withAnimation {
                viewModel.showBackground.toggle()
            }
        } label: {
            Image(systemName: "person.circle")
                .foregroundStyle(Color.blue)
                .font(.system(size: 24))
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("base-color"))
                }
        }
    }
    
    var settingButton: some View {
        Button {
            viewModel.isPresentedSettings.toggle()
            withAnimation {
                viewModel.showBackground.toggle()
            }
        } label: {
            Image(systemName: "transmission")
                .foregroundStyle(Color.blue)
                .bold()
                .font(.system(size: 24))
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .frame(width: 42, height: 42)
                        .foregroundStyle(Color("base-color"))
                }
        }

    }
}

