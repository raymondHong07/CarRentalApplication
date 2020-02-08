//
//  DetailedViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-23.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol DetailedViewControllerDelegate: class {
    
    func didTapClose()
    func didUpdateBooking()
}

final class DetailedViewController: UIViewController {

    @IBOutlet weak var backgroundOverlayView: UIView!
    @IBOutlet weak var bookNowButton: UIButton!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var mpgLabel: UILabel!
    @IBOutlet weak var topSpeedLabel: UILabel!
    @IBOutlet weak var doorsLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var transmissionLabel: UILabel!
    @IBOutlet weak var torqueLabel: UILabel!
    @IBOutlet weak var horsepowerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public var car: Car!
    public var rentalStatus: RentalStatus = .rented
    public var fromGarage: Bool = false
    public var rentedDates: NSDictionary = NSDictionary()
    
    var delegate: DetailedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBlurredView()
        setUpView()
        setUpDateLabel()
        configureView(with: car)
        checkCarAvailability()
    }
    
    private func configureView(with car: Car) {
        
        nameLabel.text = car.name
        priceLabel.text = String("$\(car.priceByDay)/")
        passengersLabel.text = String(car.passengers)
        doorsLabel.text = String(car.doors)
        mpgLabel.text = car.mpg
        topSpeedLabel.text = car.topSpeed
        
        yearLabel.text = car.year
        transmissionLabel.text = car.transmission
        torqueLabel.text = car.torque
        horsepowerLabel.text = car.horsepower
        
        if let url = URL(string: car.imageUrl) {
            
            carImageView.kf.setImage(with: url)
        }
    }
    
    private func setUpView() {
        
        bookNowButton.layer.cornerRadius = 4
        bookNowButton.layer.borderWidth = 1
    }
    
    private func setUpDateLabel() {
        
        if fromGarage {
            
            if let from = rentedDates.value(forKey: "from") as? String,
                let to = rentedDates.value(forKey: "to") as? String {
                
                let fromString = DateHelper.stringToDate(from)
                let toString = DateHelper.stringToDate(to)
                let fromDate = DateHelper.filterDateToString(fromString)
                let toDate = DateHelper.filterDateToString(toString)
                
                dateLabel.text = "\(fromDate) to \(toDate)"
                dateLabel.isHidden = false
            }
        }
    }
    
    private func setUpBlurredView() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame = self.backgroundOverlayView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundOverlayView.addSubview(blurEffectView)
    }
    
    private func checkCarAvailability() {
        
        FirebaseManager.shared.getAvailability(for: car) { (available) in
            
            if !available {
                
                // Update to rented style
                Utilities.styleRentedLabel(self.statusLabel)
                
                self.statusLabel.text = "Rented"
                self.bookNowButton.isEnabled = false
                self.bookNowButton.backgroundColor = .lightGray
            }
            
            self.checkFromGarage()
        }
    }
    
    private func checkFromGarage() {
        
        if fromGarage {
            
            if rentalStatus == .rented {
                
                bookNowButton.setTitle("Book Again", for: .normal)
                
            } else if rentalStatus == .renting {
                
                Utilities.styleRentedLabel(statusLabel)
                statusLabel.text = "Rented"
                
                bookNowButton.setTitle("Return Now", for: .normal)
                bookNowButton.backgroundColor = .black
                bookNowButton.isEnabled = true
                
            } else {
                
                Utilities.styleRentedLabel(statusLabel)
                statusLabel.text = "Rented"
                
                bookNowButton.setTitle("Cancel Booking", for: .normal)
                bookNowButton.backgroundColor = .black
                bookNowButton.isEnabled = true
            }
        }
    }
    
    private func presentBookingViewController() {
        
        let bookingVC = BookingViewController()
        bookingVC.car = car
        bookingVC.delegate = self
        
        present(bookingVC, animated: true) {}
    }

    @IBAction private func didTapBookNowButton(_ sender: Any) {
        
        if fromGarage {
            
            if rentalStatus == .renting || rentalStatus == .toBeRented {
                
                presentAlertForCancellation()
                
            } else {
                
                presentBookingViewController()
            }
            
        } else {
            
            if UserManager.shared.hasUserAlreadyRented(fromDate: FilterManager.shared.fromDate,
                                                       toDate: FilterManager.shared.toDate) {
                
                presentAlertForBookingConflict()
                
            } else {
                
                presentBookingViewController()
            }
        }
    }
    
    private func presentAlertForCancellation() {
        
        if let user = Auth.auth().currentUser,
            let fromDate = rentedDates.value(forKey: "from") as? String,
            let toDate = rentedDates.value(forKey: "to") as? String {
            
            let rentingMessage = "Are you sure you would like to return this vehicle?"
            let futureRentalMessage = "Are you sure you would like to cancel this booking?"
            
            let confirmation = UIAlertController(title: "Confirmation",
                                                 message: rentalStatus == .renting ? rentingMessage : futureRentalMessage,
                                                 preferredStyle: .alert)

            confirmation.addAction(UIAlertAction(title: "Yes",
                                                 style: .default,
                                                 handler: { (action: UIAlertAction!) in
                                                    FirebaseManager.shared.updateCarAvailabilityFor(self.car,
                                                                                                   with: user.uid,
                                                                                                   from: fromDate,
                                                                                                   to: toDate)
                                                    self.dismiss(animated: true) {
                                                       
                                                       self.delegate?.didUpdateBooking()
                                                   }
            }))

            confirmation.addAction(UIAlertAction(title: "Cancel",
                                                 style: .cancel,
                                                 handler: { (action: UIAlertAction!) in
                                                    print("Handle Cancel Logic here")

            }))

            present(confirmation, animated: true, completion: nil)
        }
    }
    
    private func presentAlertForBookingConflict() {
        
        let confirmation = UIAlertController(title: "Booking Conflict",
                                             message: "You have already booked a car within this range of dates",
                                             preferredStyle: .alert)
        
        confirmation.addAction(UIAlertAction(title: "Okay",
                                             style: .default,
                                             handler: { (action: UIAlertAction!) in
                                                print("Handle Okay Logic here")

        }))
        
        present(confirmation, animated: true, completion: nil)
    }
    
    @IBAction private func didTapCloseButton(_ sender: Any) {
        
        self.dismiss(animated: true) {}
        self.delegate?.didTapClose()
    }
}

extension DetailedViewController: BookingViewControllerDelegate {
    
    func didFinishBooking() {
        
        checkCarAvailability()
    }
}
