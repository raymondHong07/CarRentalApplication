//
//  PaymentTableViewCell.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-11-07.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageDescription: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        Utilities.styleProfileCell(self)
        selectionStyle = .none
    }
    
    func configure(with payment: Payment) {

        imageDescription.image = payment.image
        content.text = payment.content
    }
}
