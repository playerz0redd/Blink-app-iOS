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
    
    @StateObject var viewModel: MapViewModel = .init()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region,
            interactionModes: [.all],
            showsUserLocation: true,
            annotationItems: viewModel.friendsLocation
        ) { friend in
            MapAnnotation(coordinate: friend.location) {
                Image(systemName: "person.circle")
                    .font(.system(size: 40))
                    .foregroundStyle(.yellow)
                    .onTapGesture {
                        viewModel.selectFriend(friend)
                        withAnimation {
                            viewModel.region = .init(center: friend.location, span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03))
                        }
                        Task {
                            try await viewModel.getPeopleAmount()
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
            MapPitchToggle()
            MapScaleView()
        })
        .mapStyle(.standard)
        .sheet(isPresented: $viewModel.isShowingSheet, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    viewModel.showBackground = false
                }
            }
        }) {
            PersonSheet(selectedFriend: viewModel.selectedFriend!, viewModel: viewModel)
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
            Button {
                print("asd")
            } label: {
                Text("button")
            }

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
}

struct PersonSheet: View {
    var selectedFriend: UserLocation
    var viewModel: MapViewModel
    
    var body: some View {
            ZStack {
                Circles()
                    .frame(alignment: .topLeading)
                    .offset(x: -150, y: -350)
                    
                userInfo(friend: selectedFriend)

            }.overlay {
                VStack {
                    Text("📍 \(viewModel.address)")
                        .offset(y: -40)
                        .font(.system(size: 18))
                    HStack(spacing: 70) {
                        friendImages(friendAmount: selectedFriend.friendAmount)
                            .offset(x: -50)
                        rectangeView
                    }
                    
                    heartAnimation
                        .padding(.top, 110)
                    
                    Text("дружите с \(selectedFriend.friendsSince.getRuDateString()).")
                        .padding(.top, 30)
                        .foregroundStyle(.gray)
                    Text("\(viewModel.getDistanceBetweenDates(from: selectedFriend.friendsSince, to: Date.now)) дней провели вместе 😉")
                        .foregroundStyle(.gray)
                    
                }.padding(.top, 320)
            }
        .presentationDetents([.height(750)])
    }
    
    
    func userInfo(friend: UserLocation) -> some View {
        ZStack {
            Image("user")
                .resizable()
                .frame(width: 120, height: 120)
            
            Text("@\(friend.username)")
                .font(.system(size: 19))
                .bold()
                .padding(5)
                .background(RoundedRectangle(cornerSize: CGSize(width: 9, height: 9))
                    .fill(Color(red: 220/250, green: 220/250, blue: 220/250)))
                .rotationEffect(Angle(degrees: -10))
                .offset(x: 0, y: 60)
        }
        .offset(y: -200)
    }
    
    func friendImages(friendAmount: Int) -> some View {
        ZStack {
            friendWithCircle(imageUrl: "man")
            friendWithCircle(imageUrl: "woman")
                .offset(x: 30)
            friendWithCircle(imageUrl: "boy")
                .offset(x: 60)
            Text("\(friendAmount)")
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
                Text("\(viewModel.peopleVisited)")
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

