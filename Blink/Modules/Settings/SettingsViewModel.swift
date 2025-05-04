//
//  SettingsViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.05.25.
//

import Foundation
import SwiftUI
import MapKit

struct SettingsDependency {
    var mapStyle: Binding<MapStyle>
    var isLogedIn: Binding<Bool>
    var isShowingSettings: Binding<Bool>
    var currentStyleIndex: Binding<Int>
}

class SettingsViewModel: ObservableObject {
    
    private let model = SettingsModel()
    
    @Binding var mapStyle: MapStyle
    @Binding var isLogedIn: Bool
    @Published var selectedType: Int
    @Binding var isShowingSettings: Bool
    @Binding var currentStyleIndex: Int
    let mapStyles: [MapStyle] = [.standard, .hybrid, .imagery]
    
    init(dependency: SettingsDependency) {
        self._mapStyle = dependency.mapStyle
        self._isLogedIn = dependency.isLogedIn
        self._isShowingSettings = dependency.isShowingSettings
        self._currentStyleIndex = dependency.currentStyleIndex
        self.selectedType = dependency.currentStyleIndex.wrappedValue
    }
    
    func logout() {
        model.logout()
    }
    
    
}
