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
    
    func getHourAndMinutes() -> String {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self).increaseDigitAmount(upTo: 2) + ":" + calendar.component(.minute, from: self).increaseDigitAmount(upTo: 2)
    }
    
    func getDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = dateFormatter.string(from: self)
        return String(date.prefix(upTo: date.index(date.startIndex, offsetBy: 3)))
    }
    
    func getMonthAndDate() -> String {
        let calendar = Calendar.current
        return calendar.component(.day, from: self).increaseDigitAmount(upTo: 2) + calendar.component(.month, from: self).increaseDigitAmount(upTo: 2)
    }
    
    func getFullDate() -> String {
        let calendar = Calendar.current
        return calendar.component(.day, from: self).increaseDigitAmount(upTo: 2) + calendar.component(.month, from: self).increaseDigitAmount(upTo: 2) + calendar.component(.year, from: self).increaseDigitAmount(upTo: 2)
    }
    
    func getMessageDateString() -> String {
        switch self.getDistanceBetweenDates(to: Date.now) {
        case 0:
            return self.getHourAndMinutes()
        case 1...7:
            return self.getDayOfWeek()
        case 8...365:
            return self.getMonthAndDate()
        default:
            return getFullDate()
        }
    }
    
    
}
