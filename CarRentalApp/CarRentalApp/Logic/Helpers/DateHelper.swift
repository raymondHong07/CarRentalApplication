//
//  FormatHelper.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-23.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation

final class DateHelper {
 
    private static let formatter = DateFormatter()
    private static let format = "YYYY/MM/dd"
    private static let filterFormat = "MMM dd YYYY"

    class func dateToString(_ date: Date) -> String {
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    class func stringToDate(_ date: String) -> Date {
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = format
        return formatter.date(from: date)?.stripTime() ?? Date()
    }
    
    class func filterDateToString(_ date: Date) -> String {
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = filterFormat
        return formatter.string(from: date)
    }
    
    class func filterStringToDate(_ date: String) -> Date {
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = filterFormat
        return formatter.date(from: date)?.stripTime() ?? Date()
    }
    
    class func today() -> Date {
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = format
        
        return formatter.date(from: formatter.string(from: Date())) ?? Date()
    }
}
