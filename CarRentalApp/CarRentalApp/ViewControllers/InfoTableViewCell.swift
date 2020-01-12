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
        // Initialization code
        self.layer.cornerRadius = self.frame.width/20
        self.layer.borderWidth = 0.2
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        

        Utilities.styleInfoField(header, content)
        
    }
    
    func configureWith(Info: Info) {
        // Initialization code
        ImageDescription.image = Info.image
        header.text = Info.header
        content.text = Info.content

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
