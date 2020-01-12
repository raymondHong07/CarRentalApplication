//
//  Date+Filter.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-26.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation

extension Date {
    
    init(days: Int, since: Date) {
        
        let minute: TimeInterval = 60.0
        let hour: TimeInterval = 60.0 * minute
        let day: TimeInterval = 24.0 * hour
        let time: TimeInterval = Double(days) * day
        
        self.init(timeInterval: time, since: since)
    }
    
    func daysUntil(_ date: Date) -> Int {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents([.day], from: self, to: date)
        return components.day!
    }
    
    func isBetween(_ beginDate: Date, and endDate: Date) -> Bool {
        
        if compare(beginDate) == .orderedAscending {
            return false
        }
        
        if compare(endDate) == .orderedDescending {
            return false
        }
        
        return true
    }
    
    func stripTime() -> Date {
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        let date = calendar.date(from: components)
        return date!
    }
    
    func nextDay() -> Date {
        
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? Date()
    }
    
    func nextYear() -> Date {
        
        let today = Date()
        
        return Calendar.current.date(byAdding: .year, value: 1, to: today) ?? Date()
    }
    
    var localizedDescription: String {
        
        return description(with: .current)
    }
        
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        
        return date1.compare(self) == self.compare(date2)
    }
}
