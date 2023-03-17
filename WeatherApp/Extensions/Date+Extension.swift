//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation

extension Date {
    func formatted(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var weekDay: String {
        if isInToday {
            return "Today"
        }
        return formatted(with: "EEE")
    }
    
    var weekDayFull: String {
        if isInToday {
            return "Today"
        }
        return formatted(with: "EEEE")
    }
    
    var isInToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    var hour: Int {
        Calendar.current.dateComponents([.hour], from: self).hour ?? 0
    }
}


