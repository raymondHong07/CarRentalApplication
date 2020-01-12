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
        configureViewWith(car)
        checkCarAvailability()
    }
    
    private func configureViewWith(_ car: Car) {
        
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
        
        ImageManager.shared.imageForUrl(urlString: car.imageUrl, completionHandler: { (image) in
            
            if let carImage = image {
                
                self.carImageView.image = carImage
            }
        })
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
        
        let carId = car.id
        FirebaseManager.shared.getAllCars {
            
            CarManager.shared.allCars = CarManager.shared.filterCarsByDate(
                CarManager.shared.fromDate.stripTime(),
                CarManager.shared.toDate.stripTime())
            
            
            if !CarManager.shared.allCars.contains(where: {$0.id == carId}) {
                
                
                self.statusLabel.backgroundColor = UIColor(
                    red: 185/255.0,
                    green: 28/255.0,
                    blue: 29/255.0,
                    alpha: 1)
                
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
                
                statusLabel.backgroundColor = UIColor(
                    red: 185/255.0,
                    green: 28/255.0,
                    blue: 29/255.0,
                    alpha: 1)
                
                statusLabel.text = "Rented"
                
                bookNowButton.setTitle("Return Now", for: .normal)
                bookNowButton.backgroundColor = .black
                
                self.bookNowButton.isEnabled = true
                
            } else {
                
                statusLabel.backgroundColor = UIColor(
                    red: 185/255.0,
                    green: 28/255.0,
                    blue: 29/255.0,
                    alpha: 1)
                
                statusLabel.text = "Rented"
                
                bookNowButton.setTitle("Cancel Booking", for: .normal)
                bookNowButton.backgroundColor = .black
                
                self.bookNowButton.isEnabled = true
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
                // Return rental vehicle from firebase by updating the entire rentedDates dict
                
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
                                                         handler: { (action: UIAlertAction!) in FirebaseManager.shared.updateCarAvailabilityFor(self.car,
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
                
            } else {
                
                presentBookingViewController()
            }
            
        } else {
            
            if CarManager.shared.hasUserAlreadyRented() {
                
                let confirmation = UIAlertController(title: "Booking Conflict",
                                                     message: "You have already booked a car within this range of dates",
                                                     preferredStyle: .alert)
                
                confirmation.addAction(UIAlertAction(title: "Okay",
                                                     style: .default,
                                                     handler: { (action: UIAlertAction!) in
                                                        print("Handle Cancel Logic here")

                }))
                
                present(confirmation, animated: true, completion: nil)
                
            } else {
                
                presentBookingViewController()
            }
        }
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
