//
//  Payment.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-11-19.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation
import UIKit

final class Payment: NSObject {
    
    var image: UIImage?
    var buttonImage: UIImage?
    var content: String = ""
    
    enum paymentMethod: Int, CaseIterable {
        case visa
        case mastercard
        case american
    }
    
    class func initialize(type: paymentMethod, content: String, buttonImage: UIImage) -> Payment {
        
        let payment = Payment()

        payment.content = content
        payment.buttonImage = buttonImage
        
        switch type {
            
            case .visa:
                payment.image = #imageLiteral(resourceName: "visa")
                
            case .mastercard:
                payment.image = #imageLiteral(resourceName: "mastercard")
                
            case .american:
                payment.image = #imageLiteral(resourceName: "amex")
        }
    
        return payment
    }
}
