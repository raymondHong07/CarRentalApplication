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
    
    private var filterButtons: [UIButton] = []
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setUpButtonTags()
        populateButtons()
        selectCurrentFilter()
    }
        
    private func setUpButtonTags() {
        
        noneButton.tag = -1
        twoButton.tag = 2
        fiveButton.tag = 5
        sevenPlusButton.tag = 7
    }
    
    private func populateButtons() {
        
        filterButtons.append(noneButton)
        filterButtons.append(twoButton)
        filterButtons.append(fiveButton)
        filterButtons.append(sevenPlusButton)
    }
    
    private func selectCurrentFilter() {
        
        resetAllButtonStyles()
        
        for button in filterButtons {
            
            if button.tag == FilterManager.shared.passengersFilter {
                style(button)
            }
        }
    }
    
    private func resetAllButtonStyles() {
        
        for button in filterButtons {
            
            button.backgroundColor = .clear
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    private func style(_ button: UIButton) {
        
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func selectFilter(sender: AnyObject) {
        
        guard let button = sender as? UIButton else {
            return
        }
        
        resetAllButtonStyles()
        style(button)
        FilterManager.shared.passengersFilter = button.tag
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
