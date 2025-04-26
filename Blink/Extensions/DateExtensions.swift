//
//  DateExtensions.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 5.04.25.
//

import Foundation


extension Date {
    func getRuDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: self)
    }
    
    func getDistanceBetweenDates(to: Date) -> Int {
        Calendar.current.dateComponents([.day], from: self, to: to).day ?? 0
    }
    
    
}
