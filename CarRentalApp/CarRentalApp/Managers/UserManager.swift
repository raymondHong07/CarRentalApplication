//
//  UserManager.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2020-01-16.
//  Copyright © 2020 R&R. All rights reserved.
//

import Foundation
import FirebaseAuth

final class UserManager {
 
    static let shared: UserManager = {
        let instance = UserManager()
        return instance
    }()
}

extension UserManager {

    func getCarsRentedByUser() -> [Car] {
        
        var userCars: [Car] = []
        
        if let user = Auth.auth().currentUser {
            
            for car in CarManager.shared.masterListOfAllCars {
                
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
            
            for car in CarManager.shared.masterListOfAllCars {
                
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
            
            for car in CarManager.shared.masterListOfAllCars {
                
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

    func hasUserAlreadyRented(fromDate: Date, toDate: Date) -> Bool {
        
        let userRentedDates = getDatesRentedByUser()
        
        for rentedDate in userRentedDates {
            
            if let fromString = rentedDate.value(forKey: "from") as? String,
                let toString = rentedDate.value(forKey: "to") as? String {
                
                let from = DateHelper.stringToDate(fromString)
                let to = DateHelper.stringToDate(toString)
                
                if (from.isBetween(date: fromDate, andDate: toDate) && to.isBetween(date: fromDate, andDate: toDate)) {
                    
                    return true
                }
                
                if (fromDate.isBetween(date: from, andDate: to) && toDate.isBetween(date: from, andDate: to)) {

                    return true
                }
                
                if (from == fromDate && to == toDate) {
                    
                    return true
                }
            }
        }
        
        return false
    }
}
