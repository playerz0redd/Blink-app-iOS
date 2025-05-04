//
//  IntExtensions.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.05.25.
//

import Foundation


extension Int {
    
    func increaseDigitAmount(upTo: Int) -> String {
        String(format: "%0\(upTo)d", self)
    }
    
}

