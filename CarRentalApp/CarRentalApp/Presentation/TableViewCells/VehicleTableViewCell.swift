//
//  VehicleTableViewCell.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-19.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import Kingfisher

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet private weak var carNameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var passengersLabel: UILabel!
    @IBOutlet private weak var doorsLabel: UILabel!
    @IBOutlet private weak var vehicleImage: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet weak var viewVehicleButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        
        viewVehicleButton.layer.cornerRadius = 4
        viewVehicleButton.layer.borderWidth = 1
        selectionStyle = .none
    }
    
    func configure(with car: Car) {
        
        carNameLabel.text = car.name
        yearLabel.text = car.year
        passengersLabel.text = String(car.passengers)
        doorsLabel.text = String(car.doors)
        priceLabel.text = String("$\(car.priceByDay)")
        
        if let url = URL(string: car.imageUrl) {
            
            vehicleImage.kf.setImage(with: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
