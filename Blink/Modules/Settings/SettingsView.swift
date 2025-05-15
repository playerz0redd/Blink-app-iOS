//
//  SettingsView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.05.25.
//

import Foundation
import SwiftUI
import MapKit

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @Namespace var animation
    
    init(dependency: SettingsDependency) {
        _viewModel = .init(wrappedValue: .init(dependency: dependency))
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Настройки")
                .foregroundStyle(.black)
                .font(.system(size: 30, weight: .medium))
                .padding(.top, 0)
            VStack(spacing: 30) {
                Text("Выбор стиля карты")
                    .foregroundStyle(.black)
                    .font(.system(size: 30, weight: .medium))
                    .padding(0)
                
                HStack(spacing: 0) {
                    styleButton(styleName: "стандарт", index: 0, style: .standard)
                    styleButton(styleName: "гибрид", index: 1, style: .hybrid)
                    styleButton(styleName: "спутник", index: 2, style: .imagery)
                }
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundStyle(Color.black)
                        .padding(10)
                }
            }
            
            Spacer()
            
            Button {
                viewModel.isShowingSettings.toggle()
                viewModel.logout()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        viewModel.isLogedIn = false
                    }
                }
            } label: {
                Text("Выход из аккаунта")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background {
                        RoundedRectangle(cornerRadius: 23)
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 10)
                    }
                    .padding(.top, 30)
            }

        }
        .ignoresSafeArea(.all)
        .padding(.vertical, 25)
    }
    
    func styleButton(styleName: String, index: Int, style: MapStyle) -> some View {
        Button {
            viewModel.currentStyleIndex = index
            withAnimation(.spring()) {
                viewModel.selectedType = index
            }
            viewModel.mapStyle = style
        } label: {
            Text(styleName)
                .foregroundStyle(viewModel.selectedType == index ? Color.white : Color.gray)
                .frame(maxWidth: .infinity)
                .bold()
                .font(.system(size: 20))
                .background {
                    if viewModel.selectedType == index {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 40)
                            .padding(.horizontal, 15)
                            .foregroundStyle(Color.gray)
                            .opacity(0.7)
                            .matchedGeometryEffect(id: "type", in: animation)
                    }
                }
        }
    }
}
