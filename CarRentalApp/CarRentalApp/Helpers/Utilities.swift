//
//  Utilities.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-10-15.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
            
    class func styleInfoField(_ header: UILabel,_ content: UILabel) {
        header.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        
        content.font = UIFont(name:"HelveticaNeue-Light", size: 17.0)
        content.textColor = .gray
    }

    class func styleFAQField(_ header: UILabel,_ content: UILabel) {
        header.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        header.lineBreakMode = .byWordWrapping
        header.numberOfLines = 0
        
        content.font = UIFont(name:"HelveticaNeue-Light", size: 17.0)
        content.lineBreakMode = .byWordWrapping
        content.numberOfLines = 0
    }
        
    class func styleFilledButton(_ button:UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = .black
            button.layer.cornerRadius = 6.0
            button.tintColor = UIColor.white
    }
        
    class func styleRentedLabel(_ label: UILabel) {
        
        label.backgroundColor = UIColor(
            red: 185/255.0,
            green: 28/255.0,
            blue: 29/255.0,
            alpha: 1)
    }
    
    class func styleProfileCell(_ cell: UITableViewCell) {
        
        // Configure cell layers + bg colour
        cell.layer.cornerRadius = cell.frame.width/20
        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

