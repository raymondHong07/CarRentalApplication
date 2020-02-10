//
//  User.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2020-02-09.
//  Copyright © 2020 R&R. All rights reserved.
//

import Foundation

final class User: NSObject {
    
    var email: String = ""
    var address: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    
//    var rentedDates: [NSDictionary] = []
    
    class func createUser(for user: User, with data: NSDictionary) {
            
        user.email = data.value(forKey: "email") as? String ?? ""
        user.address = data.value(forKey: "address") as? String ?? ""
        user.firstName = data.value(forKey: "firstName") as? String ?? ""
        user.lastName = data.value(forKey: "lastName") as? String ?? ""
        user.phoneNumber = data.value(forKey: "phoneNumber") as? String ?? ""
        
//        user.rentedDates = data.value(forKey: "rentedDates") as? [NSDictionary] ?? []
    }
}
