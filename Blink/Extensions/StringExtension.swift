//
//  StringExtension.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import Foundation
import SwiftUI


extension String {
    func getColor() -> Color {
        let colors : [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .indigo, .mint]
        if let index = self.first?.asciiValue {
            return colors[Int(index) % (colors.count - 1)]
        } else {
            return .blue
        }
    }
}
