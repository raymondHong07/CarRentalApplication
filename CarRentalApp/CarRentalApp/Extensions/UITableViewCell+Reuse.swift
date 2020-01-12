//
//  UITableViewCell+Reuse.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-23.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    static var nibName: String {
        
        return String(describing: self)
    }
    
    class func register(with tableView: UITableView) {
        
        tableView.register(
            UINib(nibName: nibName, bundle: nil),
            forCellReuseIdentifier: identifier)
    }
}
