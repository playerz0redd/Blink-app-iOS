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
    
    func insertLineBreaks(every n: Int) -> String {
        stride(from: 0, to: self.count, by: n).map { i in
            let startIndex = self.index(self.startIndex, offsetBy: i)
            let endIndex = self.index(startIndex, offsetBy: n, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[startIndex..<endIndex])
        }.joined(separator: "\n")
    }
    
    func getPadding() -> Double {
        Double((self.count / 20 + 1) * 14)
    }
}
