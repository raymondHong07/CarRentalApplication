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
        
    func isBetween(date fromDate: Date, andDate toDate: Date) -> Bool {
        
        return fromDate.compare(self) == self.compare(toDate)
    }
}
