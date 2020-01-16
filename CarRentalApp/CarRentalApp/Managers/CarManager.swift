//
//  CarManager.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-18.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

final class CarManager {

    static let shared: CarManager = {
        let instance = CarManager()
        return instance
    }()
    
    var masterListOfAllCars: [Car] = []
    var allCars: [Car] = []
}
