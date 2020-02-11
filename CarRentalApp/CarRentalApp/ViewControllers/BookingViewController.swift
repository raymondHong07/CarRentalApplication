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
            
            FirebaseManager.shared.allCars = FilterManager.shared.filterCarsBySetDates()
        }
    }
    
    private func setUpBookingView() {
        
        if let numberOfDays = Calendar.current.dateComponents([.day], from: FilterManager.shared.fromDate, to: FilterManager.shared.toDate).day {
            
            let total = numberOfDays * car.priceByDay
            
            nameLabel.text = car.name
            daysLabel.text = "\(numberOfDays)"
            costPerDayLabel.text = "$\(car.priceByDay)"
            totalLabel.text = "$\(total)"
            dateLabel.text = "\(DateHelper.filterDateToString(FilterManager.shared.fromDate)) to \(DateHelper.filterDateToString(FilterManager.shared.toDate))"
            
            formatUserAddress()
        }
    }
    
    @IBAction private func confirmBookingTapped(_ sender: Any) {
        
        let confirmationVC = ConfirmationViewController()
        confirmationVC.delegate = self
        confirmationVC.modalPresentationStyle = .overCurrentContext
        
        if FirebaseManager.shared.allCars.contains(where: {$0.id == self.car.id}) {
            
            let from = FilterManager.shared.fromDate
            let to = FilterManager.shared.toDate
            
            FirebaseManager.shared.updateCarAvailabilityFor(self.car,
                                                            with: from,
                                                            and: to)
            FirebaseManager.shared.updateUserRentedHistoryWith(car: self.car,
                                                               from: from,
                                                               to: to)
            self.present(confirmationVC, animated: true) {}
            
        } else {
            
            confirmationVC.status = .rented
            self.present(confirmationVC, animated: true) {}
        }
    }
    
    @IBAction private func didTapCloseButton(_ sender: Any) {
        
        self.dismiss(animated: true) {}
    }
    
    private func formatUserAddress() {
        
        let currentUser = FirebaseManager.shared.currentUser
        let tokenizedString = currentUser.address.components(separatedBy: ", ")
    
        primaryAddressLabel.text = tokenizedString[0]
        secondaryAddressLabel.text = "\(tokenizedString[1]), \(tokenizedString[2]), \(tokenizedString[3])"
    }
}

extension BookingViewController: ConfirmationViewControllerDelegate {
    
    func didConfirm() {
        
        self.dismiss(animated: true) {
            
            self.delegate?.didFinishBooking()
        }
    }
}
