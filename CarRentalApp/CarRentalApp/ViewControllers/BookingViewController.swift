//
//  BookingViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-27.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol BookingViewControllerDelegate: class {
    
    func didFinishBooking()
}

class BookingViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var costPerDayLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var primaryAddressLabel: UILabel!
    @IBOutlet weak var secondaryAddressLabel: UILabel!
    public weak var car: Car!
    var delegate: BookingViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpBookingView()
        
        FirebaseManager.shared.getAllCars {
            
            CarManager.shared.allCars = FilterManager.shared.filterCarsBySetDates()
        }
    }
    
    private func setUpBookingView() {
        
        if let numberOfDays = Calendar.current.dateComponents([.day], from: CarManager.shared.fromDate, to: CarManager.shared.toDate).day {
            
            let total = numberOfDays * car.priceByDay
            
            nameLabel.text = car.name
            daysLabel.text = "\(numberOfDays)"
            costPerDayLabel.text = "$\(car.priceByDay)"
            totalLabel.text = "$\(total)"
            dateLabel.text = "\(DateHelper.filterDateToString(CarManager.shared.fromDate)) to \(DateHelper.filterDateToString(CarManager.shared.toDate))"
            
            formatUserAddress()
        }
    }
    
    private func formatUserAddress() {
        
        if let user = Auth.auth().currentUser {
            
            FirebaseManager.shared.getUserDataFor(user.uid, key: "address") { (address) in
                
                let tokenizedString = address.components(separatedBy: ", ")
                
                self.primaryAddressLabel.text = tokenizedString[0]
                self.secondaryAddressLabel.text = "\(tokenizedString[1]), \(tokenizedString[2]), \(tokenizedString[3])"
            }
        }
    }
    
    @IBAction private func confirmBookingTapped(_ sender: Any) {
        
        let confirmationVC = ConfirmationViewController()
        confirmationVC.delegate = self
        confirmationVC.modalPresentationStyle = .overCurrentContext
        
        if CarManager.shared.allCars.contains(where: {$0.id == self.car.id}) {
            
            FirebaseManager.shared.updateCarAvailabilityFor(self.car, with: CarManager.shared.fromDate, and: CarManager.shared.toDate)
            self.present(confirmationVC, animated: true) {}
            
        } else {
            
            confirmationVC.status = .rented
            self.present(confirmationVC, animated: true) {}
        }
    }
    
    @IBAction private func didTapCloseButton(_ sender: Any) {
        
        self.dismiss(animated: true) {}
    }
}

extension BookingViewController: ConfirtmationViewControllerDelegate {
    
    func didConfirm() {
        
        self.dismiss(animated: true) {
            
            self.delegate?.didFinishBooking()
        }
    }
}
