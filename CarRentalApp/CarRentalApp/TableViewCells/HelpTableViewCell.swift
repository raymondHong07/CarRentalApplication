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
        
        Utilities.styleProfileCell(self)
        Utilities.styleFAQField(header, contentDescription)
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
