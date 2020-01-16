//
//  GarageViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-29.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

public enum RentalStatus {
    
    case rented
    case renting
    case toBeRented
}

class GarageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var emptyGarageLabel: UILabel!
    
    var userCars: [Car] = []
    var userRentedDates: [NSDictionary] = []
    var userRentalStatus: [RentalStatus] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        FirebaseManager.shared.getAllCars {
            
            self.populateUserData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(roundedRect:tableContainerView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height: 20))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        tableContainerView.layer.mask = maskLayer
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    private func populateUserData() {
        
        userCars = UserManager.shared.getCarsRentedByUser()
        userRentedDates = UserManager.shared.getDatesRentedByUser()
        userRentalStatus = UserManager.shared.getRentalStatusByUser()
        
        tableView.reloadData()
        checkForEmptyGarage()
    }
    
    private func setUpTableView() {
        
        VehicleTableViewCell.register(with: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func checkForEmptyGarage() {
            
        emptyGarageLabel.isHidden = !userCars.isEmpty
        tableView.isScrollEnabled = !userCars.isEmpty
    }
}

extension GarageViewController: UITableViewDelegate {}

extension GarageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let car = userCars[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleTableViewCell.identifier)
            as? VehicleTableViewCell else {
                
                fatalError("cellForRowAt error")
        }
        
        cell.configureWith(car)
        
        if userRentalStatus[indexPath.row] == .rented {
            
            cell.viewVehicleButton.setTitle("Previously Rented", for: .normal)
            
        } else if userRentalStatus[indexPath.row] == .renting {
            
            cell.viewVehicleButton.setTitle("Currently Renting", for: .normal)
            
        } else {
            
            cell.viewVehicleButton.setTitle("Future Rental", for: .normal)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedCarVC = DetailedViewController()
        detailedCarVC.delegate = self
        detailedCarVC.modalPresentationStyle = .overFullScreen
        detailedCarVC.car = userCars[indexPath.row]
        detailedCarVC.fromGarage = true
        detailedCarVC.rentalStatus = userRentalStatus[indexPath.row]
        detailedCarVC.rentedDates = userRentedDates[indexPath.row]
        
        self.present(detailedCarVC, animated: true) {}
    }
}

extension GarageViewController: DetailedViewControllerDelegate {
    
    func didTapClose() {
         
        tableView.reloadData()
    }
    
    func didUpdateBooking() {
        
        FirebaseManager.shared.getAllCars {
            
            self.populateUserData()
        }
    }
}
