//
//  PassengerFilterTableViewCell.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-11-24.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

class PassengerFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var sevenPlusButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if CarManager.shared.passengersFilter == -1 {
            
            noneButtonTapped()
            
        } else if CarManager.shared.passengersFilter == 2 {
            
            twoButtonTapped()
            
        } else if CarManager.shared.passengersFilter == 5 {
            
            fiveButtonTapped()
            
        } else {
            
            sevenPlusButtonTapped()
        }
    }
    
    private func resetAllButtonStyles() {
        
        noneButton.backgroundColor = .clear
        twoButton.backgroundColor = .clear
        fiveButton.backgroundColor = .clear
        sevenPlusButton.backgroundColor = .clear
        
        noneButton.setTitleColor(.black, for: .normal)
        twoButton.setTitleColor(.black, for: .normal)
        fiveButton.setTitleColor(.black, for: .normal)
        sevenPlusButton.setTitleColor(.black, for: .normal)
    }

    @IBAction func noneButtonTapped() {
        
        resetAllButtonStyles()
        noneButton.backgroundColor = .black
        noneButton.setTitleColor(.white, for: .normal)
        CarManager.shared.passengersFilter = -1
    }
    
    @IBAction func twoButtonTapped() {
        
        resetAllButtonStyles()
        twoButton.backgroundColor = .black
        twoButton.setTitleColor(.white, for: .normal)
        CarManager.shared.passengersFilter = 2
    }
    
    @IBAction func fiveButtonTapped() {
        
        resetAllButtonStyles()
        fiveButton.backgroundColor = .black
        fiveButton.setTitleColor(.white, for: .normal)
        CarManager.shared.passengersFilter = 5
    }
    
    @IBAction func sevenPlusButtonTapped() {
        
        resetAllButtonStyles()
        sevenPlusButton.backgroundColor = .black
        sevenPlusButton.setTitleColor(.white, for: .normal)
        CarManager.shared.passengersFilter = 7
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
}
