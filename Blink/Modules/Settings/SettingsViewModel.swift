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
}

class SettingsViewModel: ObservableObject {
    
    private let model = SettingsModel()
    
    @Binding var mapStyle: MapStyle
    @Binding var isLogedIn: Bool
    @Published var selectedType: Int = 0
    let mapStyles: [MapStyle] = [.standard, .hybrid, .imagery]
    
    init(dependency: SettingsDependency) {
        self._mapStyle = dependency.mapStyle
        self._isLogedIn = dependency.isLogedIn
    }
    
    func logout() {
        self.isLogedIn = false
        model.logout()
    }
    
    
}
