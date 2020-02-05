//
//  HelpTableViewCell.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-11-07.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

class HelpTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var contentDescription: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setUpCell()
        Utilities.styleFAQField(header, contentDescription)
    }
    
    private func setUpCell() {
        
        // Configure UI
        layer.cornerRadius = self.frame.width/20
        layer.borderWidth = 0.2
        layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        selectionStyle = .none
    }

    func configure(with help: Help) {
        self.header.text = help.header
        self.contentDescription.text = help.contentDescription
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
