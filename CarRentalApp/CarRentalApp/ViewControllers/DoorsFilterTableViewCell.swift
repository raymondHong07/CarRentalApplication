//
//  DoorsFilterTableViewCell.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-11-24.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

class DoorsFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if CarManager.shared.doorsFilter == -1 {
            
            noneButtonTapped()
            
        } else if CarManager.shared.doorsFilter == 2 {
            
            twoButtonTapped()
            
        } else {
            
            fourButtonTapped()
        }
        
    }
    
    private func resetAllButtonStyles() {
        
        noneButton.backgroundColor = .clear
        twoButton.backgroundColor = .clear
        fourButton.backgroundColor = .clear
        
        noneButton.setTitleColor(.black, for: .normal)
        twoButton.setTitleColor(.black, for: .normal)
        fourButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func noneButtonTapped() {
        
        resetAllButtonStyles()
        noneButton.backgroundColor = .black
        noneButton.setTitleColor(.white, for: .normal)
        CarManager.shared.doorsFilter = -1
    }
    
    @IBAction func twoButtonTapped() {
        
        resetAllButtonStyles()
        twoButton.backgroundColor = .black
        twoButton.setTitleColor(.white, for: .normal)
        CarManager.shared.doorsFilter = 2
    }
    
    @IBAction func fourButtonTapped() {
        
        resetAllButtonStyles()
        fourButton.backgroundColor = .black
        fourButton.setTitleColor(.white, for: .normal)
        CarManager.shared.doorsFilter = 4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
}
