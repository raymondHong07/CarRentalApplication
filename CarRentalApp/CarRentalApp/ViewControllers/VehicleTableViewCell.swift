//
//  VehicleTableViewCell.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-19.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

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
        
        viewVehicleButton.layer.cornerRadius = 4
        viewVehicleButton.layer.borderWidth = 1
        selectionStyle = .none
    }
    
    func configureWith(_ car: Car) {
        
        carNameLabel.text = car.name
        yearLabel.text = car.year
        passengersLabel.text = String(car.passengers)
        doorsLabel.text = String(car.doors)
        priceLabel.text = String("$\(car.priceByDay)")
        
        ImageManager.shared.imageForUrl(urlString: car.imageUrl, completionHandler: { (image) in
            
            if let carImage = image {
                
                self.vehicleImage.image = carImage
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
