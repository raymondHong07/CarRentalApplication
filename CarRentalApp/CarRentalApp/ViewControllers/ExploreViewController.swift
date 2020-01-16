//
//  ExploreViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-29.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import Firebase

class ExploreViewController: UIViewController {

    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var sedanButton: UIButton!
    @IBOutlet weak var suvButton: UIButton!
    @IBOutlet weak var superCarButton: UIButton!
    @IBOutlet weak var truckButton: UIButton!
    @IBOutlet weak var coupeButton: UIButton!
    
    @IBOutlet weak var emptyFilterLabel: UILabel!
    
    private var currentType = "Explore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setUpTableView()
        setUpHeaderView()
        
        FirebaseManager.shared.getAllCars {
            
            CarManager.shared.allCars = FilterManager.shared.filterCarsBySetDates()
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        filterCarResultsBy(type: currentType)
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
    
    private func setUpHeaderView() {
    
        if let user = Auth.auth().currentUser {
            
            FirebaseManager.shared.getUserDataFor(user.uid, key: "firstName") { (userDisplayName) in
                
                self.nameLabel.text = userDisplayName
            }
        }
    }
    
    private func setUpTableView() {
        
        VehicleTableViewCell.register(with: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func resetAllButtonStyles() {
        
        exploreButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        sedanButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        suvButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        superCarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        truckButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        coupeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    private func filterCarResultsBy(type: String) {
        
        FirebaseManager.shared.getAllCars {
            
            CarManager.shared.allCars = FilterManager.shared.filterCarsBySetDates()
            
            if (type != "Explore") {
                    
                CarManager.shared.allCars = FilterManager.shared.filterCarsByType(type)
            }
            
            if (CarManager.shared.passengersFilter != -1) {
                
                CarManager.shared.allCars = FilterManager.shared.filterCarsByPassengers()
            }
            
            if (CarManager.shared.doorsFilter != -1) {
                
                CarManager.shared.allCars = FilterManager.shared.filterCarsByDoors()
            }
            
            self.currentType = type

            self.tableView.reloadData()
            self.checkForEmptyCars()
        }
        
    }
    
    private func checkForEmptyCars() {
        
        emptyFilterLabel.isHidden = !CarManager.shared.allCars.isEmpty
    }
    
    @IBAction private func didTapFilterButton(_ sender: Any) {
        
        let dateFilterVC = DateFilterViewController()
        dateFilterVC.delegate = self
        present(dateFilterVC, animated: true) {}
    }
    
    @IBAction func didTapExploreFilter(_ sender: Any) {
        
        resetAllButtonStyles()
        exploreButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: "Explore")
    }
    
    @IBAction func didTapSedanFilter(_ sender: Any) {
        
        resetAllButtonStyles()
        sedanButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: "Sedan")
    }
    
    @IBAction func didTapSUVFilter(_ sender: Any) {
        
        resetAllButtonStyles()
        suvButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: "SUV")
    }
    
    @IBAction func didTapSuperCarFilter(_ sender: Any) {
        
        resetAllButtonStyles()
        superCarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: "Super_car")
    }
    
    @IBAction func didTapTruckFilter(_ sender: Any) {
        
        resetAllButtonStyles()
        truckButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: "Truck")
    }
    
    @IBAction func didTapCoupeFilter(_ sender: Any) {
        
        resetAllButtonStyles()
        coupeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: "Coupe")
    }
    
}

extension ExploreViewController: DateFilterViewControllerDelegate {
    
    func didApplyFilter() {
        
        filterCarResultsBy(type: currentType)
    }
}

extension ExploreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CarManager.shared.allCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let car = CarManager.shared.allCars[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleTableViewCell.identifier)
            as? VehicleTableViewCell else {
                
                fatalError("cellForRowAt error")
        }
        
        cell.configureWith(car)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedCarVC = DetailedViewController()
        detailedCarVC.delegate = self
        detailedCarVC.modalPresentationStyle = .overFullScreen
        detailedCarVC.car = CarManager.shared.allCars[indexPath.row]
        
        self.present(detailedCarVC, animated: true) {}
    }
}

extension ExploreViewController: DetailedViewControllerDelegate {
    
    func didTapClose() {
        
        filterCarResultsBy(type: currentType)
    }
    
    func didUpdateBooking() {}
}

extension ExploreViewController: UITableViewDelegate {
    
}

//extension ExploreViewController {
//
//    func testFilter() {
//
//        FirebaseManager.shared.getAllCars {
//
//            // Create test dates
//
//            // all available
//            let from = DateHelper.stringToDate("2019/12/1")
//            let to = DateHelper.stringToDate("2019/12/5")
//
//            // only Audi available
//            //            let from = DateHelper.stringToDate("2019/10/1")
//            //            let to = DateHelper.stringToDate("2019/12/5")
//
//            // all but McLaren available
//            //            let from = DateHelper.stringToDate("2019/10/16")
//            //            let to = DateHelper.stringToDate("2019/10/29")
//
//            let filteredCars = CarManager.shared.filterCarsByDate(from, to)
//
//            for car in filteredCars {
//
//                NSLog("%@", car.name)
//            }
//        }
//    }
//
//    func testUpdateCarAvailablilityForNew() {
//
//        FirebaseManager.shared.getAllCars {
//
//            for car in CarManager.shared.allCars {
//
//                if car.make == "Audi" {
//
//                    let newFromDate = DateHelper.stringToDate("2019/12/20")
//                    let newToDate = DateHelper.stringToDate("2019/12/25")
//
//                    FirebaseManager.shared.updateCarAvailabilityFor(car, with: newFromDate, and: newToDate)
//                }
//            }
//        }
//    }
//
//    func testUpdateCarAvailablilityForExisting() {
//
//        FirebaseManager.shared.getAllCars {
//
//            for car in CarManager.shared.allCars {
//
//                if car.make == "McLaren" {
//
//                    let newFromDate = DateHelper.stringToDate("2019/12/20")
//                    let newToDate = DateHelper.stringToDate("2019/12/25")
//
//                    FirebaseManager.shared.updateCarAvailabilityFor(car, with: newFromDate, and: newToDate)
//                }
//            }
//        }
//    }
//}
