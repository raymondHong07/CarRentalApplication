//
//  Car.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-18.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation

final class Car: NSObject {
    
    var id: Int = 0
    var make: String = ""
    var name: String = ""
    var year: String = ""
    var horsepower: String = ""
    var torque: String = ""
    var topSpeed: String = ""
    var engine: String = ""
    var mpg: String = ""
    var transmission: String = ""
    var type: String = ""
    var imageUrl: String = ""
    var doors: Int = 0
    var passengers: Int = 0
    var priceByDay: Int = 0
    var priceByHour: Int = 0
    var colours: NSArray = []
    
    // To be made into own classes
    var rentedDates: [NSDictionary] = []
    var reviews: NSArray = []
    
    class func createCarWith(data: NSDictionary) -> Car {
     
        let car = Car()
        
        car.id = data.value(forKey: "id") as? Int ?? 0
        
        car.make = data.value(forKey: "make") as? String ?? ""
        car.name = data.value(forKey: "name") as? String ?? ""
        car.year = data.value(forKey: "year") as? String ?? ""
        car.horsepower = data.value(forKey: "horsepower") as? String ?? ""
        car.torque = data.value(forKey: "torque") as? String ?? ""
        car.topSpeed = data.value(forKey: "topSpeed") as? String ?? ""
        car.engine = data.value(forKey: "engine") as? String ?? ""
        car.mpg = data.value(forKey: "mpg") as? String ?? ""
        car.transmission = data.value(forKey: "transmission") as? String ?? ""
        car.type = data.value(forKey: "type") as? String ?? ""
        car.imageUrl = data.value(forKey: "imageUrl") as? String ?? ""
        
        car.doors = data.value(forKey: "doors") as? Int ?? 0
        car.passengers = data.value(forKey: "passengers") as? Int ?? 0
        car.priceByDay = data.value(forKey: "priceDay") as? Int ?? 0
        car.priceByHour = data.value(forKey: "priceHour") as? Int ?? 0
        
        car.colours = data.value(forKey: "colours") as? NSArray ?? []
        car.rentedDates = data.value(forKey: "rentedDates") as? [NSDictionary] ?? []
        car.reviews = data.value(forKey: "reviews") as? NSArray ?? []
        
        return car
    }
}
