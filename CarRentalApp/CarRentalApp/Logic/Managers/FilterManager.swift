//
//  FilterManager.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2020-01-16.
//  Copyright © 2020 R&R. All rights reserved.
//

import Foundation

final class FilterManager {
 
    static let shared: FilterManager = {
        let instance = FilterManager()
        return instance
    }()
    
    public enum FilterType {
        
        static let explore = "Explore"
        static let sedan = "Sedan"
        static let suv = "SUV"
        static let superCar = "Super_car"
        static let truck = "Truck"
        static let coupe = "Coupe"
    }
    
    var fromDate = Date()
    var toDate = Date().nextDay()
    var passengersFilter = -1
}

extension FilterManager {
    
    func filterCarsBySetDates() -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in FirebaseManager.shared.allCars {
            
            var fromDates: [String] = []
            var toDates: [String] = []
            for dictionary in car.rentedDates {
                
                if let fromDateForCar = dictionary.value(forKey: "from") as? String,
                    let toDateForCar = dictionary.value(forKey: "to") as? String{
                    
                    fromDates.append(fromDateForCar)
                    toDates.append(toDateForCar)
                }
            }
            
            if !fromDates.isEmpty && !toDates.isEmpty {
                
                var available = true
                
                for i in 0...fromDates.count-1 {
                    
                    let from = DateHelper.stringToDate(fromDates[i])
                    let to = DateHelper.stringToDate(toDates[i])
                    
                    // Example of filer dates Feb 18 to Feb 19
                    // Example of rented dates Feb 18 to Feb 24
                    // Only one of the dates need to be in the range to determine that the car is not available
                    available = !from.isBetween(fromDate, and: toDate)
                    
                    if available {
                        
                        available = !to.isBetween(fromDate, and: toDate)
                    }
                }

                if available {

                    filteredCars.append(car)
                }
                
            } else {
                
                // Car has no rentedDates meaning it is always free
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
    
    func filterCarsByType(_ type: String) -> [Car] {
        
        // No filtering needed
        if type == FilterType.explore {
            
            return FirebaseManager.shared.allCars
        }
        
        var filteredCars: [Car] = []
        for car in FirebaseManager.shared.allCars {
                
            if car.type == type {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
        
    func filterCarsByPassengers() -> [Car] {
        
        // No filtering needed
        if passengersFilter == -1  {
            
            return FirebaseManager.shared.allCars
        }
        
        var filteredCars: [Car] = []
        for car in FirebaseManager.shared.allCars {
            
            if car.passengers == passengersFilter || (passengersFilter == 7 && car.passengers >= 7) {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
}
