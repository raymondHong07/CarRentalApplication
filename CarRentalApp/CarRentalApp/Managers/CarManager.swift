//
//  CarManager.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-18.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import FirebaseAuth

final class CarManager {

    static let shared: CarManager = {
        let instance = CarManager()
        return instance
    }()
    
    var masterListOfAllCars: [Car] = []
    var allCars: [Car] = []
    var fromDate = Date()
    var toDate = Date().nextDay()
    var passengersFilter = -1
    var doorsFilter = -1
}

extension CarManager {
    
    func getCarsRentedByUser() -> [Car] {
        
        var userCars: [Car] = []
        
        if let user = Auth.auth().currentUser {
            
            for car in masterListOfAllCars {
                
                for dictionary in car.rentedDates {
                    
                    if let uid = dictionary.value(forKey: "by") as? String,
                        user.uid == uid {
                        
                        userCars.append(car)
                    }
                }
            }
            
        }
        
        return userCars
    }
    
    func getDatesRentedByUser() -> [NSDictionary] {
        
        var userRentedDates: [NSDictionary] = []
        
        if let user = Auth.auth().currentUser {
            
            for car in masterListOfAllCars {
                
                for dictionary in car.rentedDates {
                    
                    if let uid = dictionary.value(forKey: "by") as? String,
                        user.uid == uid {
                        
                        userRentedDates.append(dictionary)
                    }
                }
            }
            
        }
        
        return userRentedDates
    }
    
    func getRentalStatusByUser() -> [RentalStatus] {
        
        var userRentalStatus: [RentalStatus] = []
        
        if let user = Auth.auth().currentUser {
            
            for car in masterListOfAllCars {
                
                for dictionary in car.rentedDates {
                    
                    if let uid = dictionary.value(forKey: "by") as? String,
                        user.uid == uid,
                        let fromString = dictionary.value(forKey: "from") as? String,
                        let toString = dictionary.value(forKey: "to") as? String {
                        
                        let rentedFromDate = DateHelper.stringToDate(fromString)
                        let rentedToDate = DateHelper.stringToDate(toString)
                        
                        if DateHelper.today() < rentedFromDate {
                            
                            userRentalStatus.append(.toBeRented)
                            
                        } else if DateHelper.today() >= rentedFromDate && DateHelper.today() < rentedToDate {
                            
                            userRentalStatus.append(.renting)
                            
                        } else {
                            
                            userRentalStatus.append(.rented)
                        }
                    }
                }
            }
            
        }
        
        return userRentalStatus
    }
    
    func hasUserAlreadyRented() -> Bool {
        
        let userRentedDates = getDatesRentedByUser()
        
        for rentedDate in userRentedDates {
            
            if let fromString = rentedDate.value(forKey: "from") as? String,
                let toString = rentedDate.value(forKey: "to") as? String {
                
                let from = DateHelper.stringToDate(fromString)
                let to = DateHelper.stringToDate(toString)
                
                if (!from.isBetween(date: fromDate, andDate: toDate) && !to.isBetween(date: fromDate, andDate: toDate)) {
                    
                } else {
                    
                    return true
                }
                
                if (!fromDate.isBetween(date: from, andDate: to) && !toDate.isBetween(date: from, andDate: to)) {

                } else {

                    return true
                }
                
                if (from == fromDate && to == toDate) {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func filterCarsByType(_ type: String) -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in allCars {
            
            if car.type == type {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
    
    func filterCarsByPassengers() -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in allCars {
            
            if car.passengers == passengersFilter || (car.passengers >= 7 && passengersFilter == 7) {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
    
    func filterCarsByDoors() -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in allCars {
            
            if car.doors == doorsFilter {
                
                filteredCars.append(car)
            }
        }
        
        return filteredCars
    }
    
    func filterCarsByDate(_ from: Date, _ to: Date) -> [Car] {
        
        var filteredCars: [Car] = []
        
        for car in allCars {
            
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
                    
                    let fromDate = DateHelper.stringToDate(fromDates[i])
                    let toDate = DateHelper.stringToDate(toDates[i])
                    
                    if (!fromDate.isBetween(date: from, andDate: to) && !toDate.isBetween(date: from, andDate: to)) {
                        
//                        print("true")
                    } else {
                        
                        available = false
                    }
                    
                    if (!from.isBetween(date: fromDate, andDate: toDate) && !to.isBetween(date: fromDate, andDate: toDate)) {

//                        print("true")
                    } else {

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
