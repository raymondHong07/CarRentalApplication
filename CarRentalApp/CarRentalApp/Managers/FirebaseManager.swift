//
//  FirebaseManager.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-18.
//  Copyright © 2019 R&R. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

final class FirebaseManager {
    
    static let shared: FirebaseManager = {
        let instance = FirebaseManager()
        return instance
    }()
    
    private var ref: DatabaseReference!
    var masterListOfAllCars: [Car] = []
    var allCars: [Car] = []
    var currentUser: User = User()
}

extension FirebaseManager {
    
    func getUser(completion: @escaping () -> Void) {
        
        if let user = Auth.auth().currentUser {
            
            ref = Database.database().reference()
            ref.observe(.childAdded) { (snapshot) in
                
                if let data = snapshot.value as? NSDictionary {
                    
                    for userData in data {
                        
                        if let userKey = userData.key as? String,
                        user.uid == userKey,
                        let userDataDictionary = userData.value as? NSDictionary {
                            
                            User.createUser(for: self.currentUser, with: userDataDictionary)
                        }
                    }
                }
                
                completion()
            }
        }
    }
        
    func getFAQs(completion: @escaping (_ field: Help) -> Void) {
        
        ref = Database.database().reference()
        
        ref.observe(.childAdded) { (snapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                for FAQData in data {
                    
                    if let header = FAQData.key as? String,
                        let content = FAQData.value as? String {
                        
                            completion(Help.createFAQWith(name: header, data: content))
                    }
                }
            }
        }
    }
    
    func getAllCars(completion: @escaping () -> Void) {
        
        allCars = []
        masterListOfAllCars = []
        
        ref = Database.database().reference()
        
        ref.observe(.childAdded) { (snapshot) in
            
            if let data = snapshot.value as? NSArray {
                
                for carData in data {
                    
                    if let carDataDictionary = carData as? NSDictionary {
                        
                        let car = Car.createCarWith(data: carDataDictionary)
                        self.masterListOfAllCars.append(car)
                    }
                }
                self.masterListOfAllCars.sort(by: {$0.name < $1.name})
                self.allCars = self.masterListOfAllCars
            }
            
            completion()
        }
    }
    
    func getAvailability(for car: Car, completion: @escaping (_ available: Bool) -> Void) {
        
        getAllCars {
            
            self.allCars = FilterManager.shared.filterCarsBySetDates()
            completion(self.allCars.contains(where: {$0.id == car.id}))
        }
    }
    
    func updateCarAvailabilityFor(_ vehicle: Car, with from: Date, and to: Date) {
        
        var rentedDates: [NSDictionary] = []
        let fromDate = DateHelper.dateToString(from)
        let toDate = DateHelper.dateToString(to)

        if vehicle.rentedDates.isEmpty {
            
            rentedDates = createRentedDatesWith(fromDate, toDate)

        } else {
            
            rentedDates = appendToRentedDatesWith(rentedDates: vehicle.rentedDates, fromDate, toDate)
        }
        
        ref.child("Cars/\(vehicle.id)/rentedDates").setValue(rentedDates)
    }
    
    func updateUserRentedHistoryWith(car: Car, from: Date, to: Date) {
        
        var rentedHistory: [NSDictionary] = []
        let fromDate = DateHelper.dateToString(from)
        let toDate = DateHelper.dateToString(to)
        
        if currentUser.rentedHistory.isEmpty {
            
            rentedHistory = createRentedDatesWith(fromDate, toDate, rentedCar: car)
            
        } else {
            
            rentedHistory = appendToRentedDatesWith(rentedDates: currentUser.rentedHistory,
                                                    fromDate,
                                                    toDate,
                                                    rentedCar: car)
        }
        
        if let user = Auth.auth().currentUser {
            
            ref.child("Users/\(user.uid)/rentedHistory").setValue(rentedHistory)
        }
    }
    
    func updateUserDataFor(key: String, newValue: String) {
        
        if let user = Auth.auth().currentUser {
                
            ref.child("users/\(user.uid)/\(key)").setValue(newValue)
        }
    }
    
    func cancelBookingFor(_ vehicle: Car, with identifier: String, from: String, to: String) {
        
        var rentedDates: [NSDictionary] = []
        
        // Remove dates from Cars data
        //
        rentedDates = removeFromRentedDatesWith(rentedDates: vehicle.rentedDates,
                                                identifier: identifier,
                                                from: from,
                                                to: to)
        ref.child("Cars/\(vehicle.id)/rentedDates").setValue(rentedDates)
    }
    
    func cancelBookingFor(_ vehicle: Car, with identifier: Int, from: String, to: String) {
        
        var rentedHistory: [NSDictionary] = []
        
        // Remove history from User data
        //
        rentedHistory = removeFromRentedHistoryWith(rentedHistory: currentUser.rentedHistory,
                                                    identifier: identifier,
                                                    from: from,
                                                    to: to)
        ref.child("Users/\(currentUser.id)/rentedHistory").setValue(rentedHistory)
    }
    
    func updateUserEmailWith(_ newEmail: String, currentPassword: String, completion: @escaping (_ success: Bool) -> Void) {
        
        if let user = Auth.auth().currentUser,
            let email = user.email {
            // re authenticate the user
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            
            user.reauthenticate(with: credential) { (data, error) in
                
                if error != nil {
                    
                    completion(false)
                    
                } else {
                    
                    user.updateEmail(to: newEmail) { (error) in
                        
                        if error == nil {
                            
                            self.updateUserDataFor(key: "email", newValue: newEmail)
                            completion(true)
                            
                        } else {
                            
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    func updateUserPasswordWith(_ newPassword: String, currentPassword: String, completion: @escaping (_ success: Bool) -> Void) {
        
        if let user = Auth.auth().currentUser,
            let email = user.email {
            // re authenticate the user
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            
            user.reauthenticate(with: credential) { (data, error) in
                
                if error != nil {
                    
                    completion(false)
                    
                } else {
                    
                    user.updatePassword(to: newPassword) { (error) in
                        
                        if error == nil {
                            
                            completion(true)
                            
                        } else {
                            
                            completion(false)
                        }
                    }
                }
            }
        }
    }
}

extension FirebaseManager {

    private func createRentedDatesWith(_ fromDate: String, _ toDate: String, rentedCar: Car? = nil) -> [NSDictionary] {

        var rentedDates: [NSDictionary] = []
        let date = NSMutableDictionary()
        
        date.setValue(fromDate, forKey: "from")
        date.setValue(toDate, forKey: "to")
        
        if let car = rentedCar {
            
            date.setValue(car.id, forKey: "carId")
            
        } else {
            
            if let user = Auth.auth().currentUser {
                
                date.setValue(user.uid, forKey: "by")
            }
        }

        rentedDates.append(date)

        return rentedDates
    }

    private func appendToRentedDatesWith(rentedDates: [NSDictionary],_ fromDate: String, _ toDate: String, rentedCar: Car? = nil) -> [NSDictionary] {

        var updatedRentedDates: [NSDictionary] = rentedDates
        let date = NSMutableDictionary()
        
        date.setValue(fromDate, forKey: "from")
        date.setValue(toDate, forKey: "to")
        
        
        if let car = rentedCar {
            
            date.setValue(car.id, forKey: "carId")
            
        } else {
            
            if let user = Auth.auth().currentUser {
                
                date.setValue(user.uid, forKey: "by")
            }
        }

        updatedRentedDates.append(date)

        return updatedRentedDates
    }
    
    private func removeFromRentedDatesWith(rentedDates: [NSDictionary], identifier userId: String, from fromDate: String, to toDate: String) -> [NSDictionary] {

        var updatedRentedDates: [NSDictionary] = rentedDates
        
        
        for (index, dictionary) in updatedRentedDates.enumerated() {
            
            if let rentUserId = dictionary.value(forKey: "by") as? String,
                let rentedFrom = dictionary.value(forKey: "from") as? String,
                let rentedTo = dictionary.value(forKey: "to") as? String,
                userId == rentUserId,
                fromDate == rentedFrom,
                toDate == rentedTo {
                
                updatedRentedDates.remove(at: index)
            }
        }

        return updatedRentedDates
    }
    
    private func removeFromRentedHistoryWith(rentedHistory: [NSDictionary], identifier carId: Int, from fromDate: String, to toDate: String) -> [NSDictionary] {

        var updatedRentedHistory: [NSDictionary] = rentedHistory
        
        
        for (index, dictionary) in updatedRentedHistory.enumerated() {
            
            if let rentedCarId = dictionary.value(forKey: "carId") as? Int,
                let rentedFrom = dictionary.value(forKey: "from") as? String,
                let rentedTo = dictionary.value(forKey: "to") as? String,
                carId == rentedCarId,
                fromDate == rentedFrom,
                toDate == rentedTo {
                
                updatedRentedHistory.remove(at: index)
            }
        }

        return updatedRentedHistory
    }
}
