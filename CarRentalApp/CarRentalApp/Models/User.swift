//
//  User.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2020-02-09.
//  Copyright © 2020 R&R. All rights reserved.
//

import Foundation
import FirebaseAuth

final class User: NSObject {
    
    var id: String = ""
    var email: String = ""
    var address: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    
    var rentedHistory: [NSDictionary] = []
    
    class func createUser(for user: User, with data: NSDictionary) {
        
        if let currentUser = Auth.auth().currentUser {
            
            user.id = currentUser.uid
        }
        
        user.email = data.value(forKey: "email") as? String ?? ""
        user.address = data.value(forKey: "address") as? String ?? ""
        user.firstName = data.value(forKey: "firstName") as? String ?? ""
        user.lastName = data.value(forKey: "lastName") as? String ?? ""
        user.phoneNumber = data.value(forKey: "phoneNumber") as? String ?? ""
        user.rentedHistory = data.value(forKey: "rentedHistory") as? [NSDictionary] ?? []
    }
}
