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
    
    class func styleWelcomeLabel(_ label:UILabel) {
        label.font = UIFont(name: "Helvetica Neue", size: 30)
        label.textColor = UIColor.white
    }
    
    class func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        //let rgbcolor = #colorLiteral(red: 0.1789781749, green: 0.663659811, blue: 0.3821850121, alpha: 1)
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height -
            2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.black.cgColor
        
        //Remove border on text field
        textfield.borderStyle = .none
        
        //Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    
    }
    
    class func styleFilledButton(_ button:UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = .black
            button.layer.cornerRadius = 6.0
            button.tintColor = UIColor.white
    }
    
    class func styleHollowButton(_ button:UIButton) {
        
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
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
    
    class func isPasswordValid(_ password: String) -> Bool {
        
        //Ensures password contains:
        //Ensures password has a minimum of 8 characters
        //Ensures password has at least one lowercase
        //Ensures passward has at least one uppercase
        //Ensures password has at least one digit
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d\\W]{8,}$")
        print(passwordTest.evaluate(with: password))
        return passwordTest.evaluate(with: password)
        
    }
}

