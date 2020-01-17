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
        // Initialization code
        self.layer.cornerRadius = self.frame.width/20
        self.layer.borderWidth = 0.2
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }

    func configureWith(Payment: Payment) {

        imageDescription.image = Payment.image
        content.text = Payment.content
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
