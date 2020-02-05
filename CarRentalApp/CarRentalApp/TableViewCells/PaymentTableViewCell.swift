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
        setUpCell()
    }
    
    private func setUpCell() {
        
        // Configure UI
        layer.cornerRadius = self.frame.width/20
        layer.borderWidth = 0.2
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        selectionStyle = .none
    }

    func configure(with payment: Payment) {

        imageDescription.image = payment.image
        content.text = payment.content
    }
}
