//
//  Info.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-11-10.
//  Copyright © 2019 R&R. All rights reserved.
//

import Foundation
import UIKit

final class Info: NSObject {
    
    var image: UIImage?
    var buttonImage: UIImage?
    var header: String = ""
    var content: String = ""
    var type: ProfileField = .email
    
    class func initialize(image: UIImage, title: String, content: String, buttonImage: UIImage, type: ProfileField? = nil) -> Info {
        
        let info = Info()
        
        info.image = image
        info.buttonImage = buttonImage
        info.header = title
        info.content = content
        info.type = type ?? .email
    
        return info
    }
}
