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
    
    var fromDate = Date()
    var toDate = Date().nextDay()
    var passengersFilter = -1
    var doorsFilter = -1
}

extension FilterManager {
    
    func filterCarsByType(_ type: String) -> [Car] {
            
        var filteredCars: [Car] = []
            
        for car in CarManager.shared.allCars {
                
                if car.type == type {
                    
                    filteredCars.append(car)
                }
            }
            
            return filteredCars
    }
        
    func filterCarsByPassengers() -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in CarManager.shared.allCars {
            
            if car.passengers == passengersFilter || (car.passengers >= 7 && passengersFilter == 7) {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
    
    func filterCarsByDoors() -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in CarManager.shared.allCars {
            
            if car.doors == doorsFilter {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
    
    func filterCarsBySetDates() -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in CarManager.shared.allCars {
            
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
                    
                    if (fromDate.isBetween(date: from, andDate: to) && toDate.isBetween(date: from, andDate: to)) {
                        
                        available = false
                    }
                    
                    if (from.isBetween(date: fromDate, andDate: toDate) && to.isBetween(date: fromDate, andDate: toDate)) {

                        available = false
                    }
                    
                    if (from == fromDate && to == toDate) {
                        
                        available = false
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
    
}
