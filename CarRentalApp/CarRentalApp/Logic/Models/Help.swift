//
//  Help.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-11-18.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation

final class Help: NSObject {
    
    var header: String = ""
    var contentDescription: String = ""
    
    class func createFAQWith(name: String, data: String) -> Help {
        
        let help = Help()
        
        help.header = name
        help.contentDescription = data
    
        return help
    }
}
