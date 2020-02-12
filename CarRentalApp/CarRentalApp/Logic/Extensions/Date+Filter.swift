//
//  Date+Filter.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-26.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation

extension Date {
    
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
}
