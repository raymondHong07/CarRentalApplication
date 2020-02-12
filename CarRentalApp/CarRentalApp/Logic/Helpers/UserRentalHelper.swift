//
//  UserRentalHelper.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2020-02-09.
//  Copyright © 2020 R&R. All rights reserved.
//

import Foundation
import FirebaseAuth

struct RentedCars {
    
    var rentedCars: [Car]
    var rentedDates: [NSDictionary]
    var rentalStatus: [RentalStatus]
}

final class UserRentalHelper {
    
    class func getCarsRentedByUser() -> RentedCars {
        
        let allCars = FirebaseManager.shared.masterListOfAllCars
        let currentUser = FirebaseManager.shared.currentUser
        var userCars: [Car] = []
        
        // Get all carIds from User's RentedHistory
        //
        if let userRentedCars = FirebaseManager.shared.currentUser.rentedHistory.map({$0.value(forKey: "carId")}) as? [Int] {
            
            // Filter all cars by rented car ids to get all user rented cars
            //
            userCars = allCars.filter({ userRentedCars.contains($0.id) })
        }
        
        var userRentedDates = [NSDictionary](repeating: NSDictionary(), count: userCars.count)
        var userRentalStatus = [RentalStatus](repeating: .toBeRented, count: userCars.count)
                
        // Get rental dates and status for all user rented cars
        //
        for date in currentUser.rentedHistory {
            
            if let fromString = date.value(forKey: "from") as? String,
                let toString = date.value(forKey: "to") as? String,
                let carId = date.value(forKey: "carId") as? Int,
                let index = userCars.firstIndex(where: {$0.id == carId}) {
                
                let rentedFromDate = DateHelper.stringToDate(fromString)
                let rentedToDate = DateHelper.stringToDate(toString)
                
                userRentedDates[index] = date
                                    
                if DateHelper.today() < rentedFromDate {
                    
                    userRentalStatus[index] = .toBeRented
                    
                } else if DateHelper.today() >= rentedFromDate && DateHelper.today() < rentedToDate {
                    
                    userRentalStatus[index] = validateCurrentRentalStatusWith(from: fromString,
                                                                              to: toString,
                                                                              carId: carId)
                } else {
                    
                    userRentalStatus[index] = .rented
                }
            }
        }
        
        return RentedCars(rentedCars: userCars,
                          rentedDates: userRentedDates,
                          rentalStatus: userRentalStatus)
    }
    
    private class func validateCurrentRentalStatusWith(from: String, to: String, carId: Int) -> RentalStatus {
        
        // Corner case: when currently rented car is returned it should become previously rented
        //
        var rentalStatus: RentalStatus = .rented
        
        if let index = FirebaseManager.shared.masterListOfAllCars.firstIndex(where: {$0.id == carId}) {
            
            for dates in FirebaseManager.shared.masterListOfAllCars[index].rentedDates {
                
                if let fromString = dates.value(forKey: "from") as? String,
                    let toString = dates.value(forKey: "to") as? String,
                    let userId = dates.value(forKey: "by") as? String,
                    FirebaseManager.shared.currentUser.id == userId,
                    fromString == from,
                    toString == to {
                    
                        rentalStatus = .renting
                }
            }
        }
        
        return rentalStatus
    }
    
    class func hasUserAlreadyRented(fromDate: Date, toDate: Date) -> Bool {

        for rentedDate in FirebaseManager.shared.currentUser.rentedHistory {

            if let fromString = rentedDate.value(forKey: "from") as? String,
                let toString = rentedDate.value(forKey: "to") as? String {

                let from = DateHelper.stringToDate(fromString)
                let to = DateHelper.stringToDate(toString)
                
                if from.isBetween(fromDate, and: toDate) || to.isBetween(fromDate, and: toDate) {
                    
                    return true
                }
            }
        }

        return false
    }
}
