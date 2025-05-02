//
//  StringExtension.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import Foundation
import SwiftUI


extension String {
    func getColor() -> [Color] {
        let colors : [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .indigo, .mint]
        if let index = self.first?.asciiValue {
            let hue = Double((Int(index) * 137) % 360) / 360.0
            let colorArray: [Color] = [
                Color(hue: hue, saturation: 0.8, brightness: 0.6),
                Color(hue: hue, saturation: 0.8, brightness: 0.8),
                Color(hue: hue, saturation: 1, brightness: 1)
            ]
            return colorArray
        } else {
            return [.blue]
        }
    }
}
