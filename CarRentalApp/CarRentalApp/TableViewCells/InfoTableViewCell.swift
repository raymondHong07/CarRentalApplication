//
//  InfoTableViewCell.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-11-07.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ImageDescription: UIImageView!

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        Utilities.styleProfileCell(self)
        Utilities.styleInfoField(header, content)
    }
    
    func configure(with info: Info) {

        ImageDescription.image = info.image
        header.text = info.header
        content.text = info.content

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
