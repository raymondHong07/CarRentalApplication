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
    
    var ref: DatabaseReference!
}

extension FirebaseManager {
    
    func getUserDataFor(_ userId: String, key: String, completion: @escaping (_ userInfo: String) -> Void) {

        ref = Database.database().reference()
        
        ref.observe(.childAdded) { (snapshot) in

        if let data = snapshot.value as? NSDictionary {

            for userData in data {

                    if let userKey = userData.key as? String,

                        userId == userKey,
                        let userDataDictionary = userData.value as? NSDictionary,
                        let userInfo = userDataDictionary.value(forKey: key) as? String {
                          
                        completion(userInfo)

                    }
                }
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
        
        CarManager.shared.allCars = []
        CarManager.shared.masterListOfAllCars = []
        
        ref = Database.database().reference()
        
        ref.observe(.childAdded) { (snapshot) in
            
            if let data = snapshot.value as? NSArray {
                
                for carData in data {
                    
                    if let carDataDictionary = carData as? NSDictionary {
                        
                        let car = Car.createCarWith(data: carDataDictionary)
                        CarManager.shared.masterListOfAllCars.append(car)
                    }
                }
                CarManager.shared.masterListOfAllCars.sort(by: {$0.name < $1.name})
                CarManager.shared.allCars = CarManager.shared.masterListOfAllCars
            }
            
            completion()
        }
    }
    
    func getAvailability(for car: Car, completion: @escaping (_ available: Bool) -> Void) {
        
        getAllCars {
            
            CarManager.shared.allCars = FilterManager.shared.filterCarsBySetDates()
            completion(CarManager.shared.allCars.contains(where: {$0.id == car.id}))
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
    
    func updateUserDataFor(key: String, newValue: String) {
        
        if let user = Auth.auth().currentUser {
                
            ref.child("users/\(user.uid)/\(key)").setValue(newValue)
        }
    }
    
    func updateCarAvailabilityFor(_ vehicle: Car, with userId: String, from: String, to: String) {
        
        var rentedDates: [NSDictionary] = []
        
        rentedDates = removeFromRentedDatesWith(rentedDates: vehicle.rentedDates,
                                  userId,
                                  from,
                                  to)
        
        ref.child("Cars/\(vehicle.id)/rentedDates").setValue(rentedDates)
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

    private func createRentedDatesWith(_ fromDate: String, _ toDate: String) -> [NSDictionary] {

        var rentedDates: [NSDictionary] = []
        let date = NSMutableDictionary()
        
        if let user = Auth.auth().currentUser {
            
            date.setValue(fromDate, forKey: "from")
            date.setValue(toDate, forKey: "to")
            date.setValue(user.uid, forKey: "by")
        }

        rentedDates.append(date)

        return rentedDates
    }

    private func appendToRentedDatesWith(rentedDates: [NSDictionary],_ fromDate: String, _ toDate: String) -> [NSDictionary] {

        var updatedRentedDates: [NSDictionary] = rentedDates
        let date = NSMutableDictionary()
        
        if let user = Auth.auth().currentUser {

            date.setValue(fromDate, forKey: "from")
            date.setValue(toDate, forKey: "to")
            date.setValue(user.uid, forKey: "by")
        }

        updatedRentedDates.append(date)

        return updatedRentedDates
    }
    
    private func removeFromRentedDatesWith(rentedDates: [NSDictionary], _ userId: String, _ fromDate: String, _ toDate: String) -> [NSDictionary] {

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
}
