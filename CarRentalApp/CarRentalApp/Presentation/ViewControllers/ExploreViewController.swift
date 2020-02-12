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
    @IBOutlet weak var greetingLabel: UILabel!
    
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var sedanButton: UIButton!
    @IBOutlet weak var suvButton: UIButton!
    @IBOutlet weak var superCarButton: UIButton!
    @IBOutlet weak var truckButton: UIButton!
    @IBOutlet weak var coupeButton: UIButton!
    
    @IBOutlet weak var emptyFilterLabel: UILabel!
    
    private var currentType: String = FilterManager.FilterType.explore
    private var filterButtons: [UIButton] = []
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        setUpTableView()
        setUpHeaderView()
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        reloadTableData()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        styleView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    private func styleView() {
        
        // Style view with rounded top corners
        let path = UIBezierPath(roundedRect:tableContainerView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 20, height: 20))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        tableContainerView.layer.mask = maskLayer
    }
    
    private func setUpHeaderView() {
        
        FirebaseManager.shared.getUser {
            
            self.nameLabel.text = FirebaseManager.shared.currentUser.firstName
            self.greetingLabel.isHidden = false
        }
    }
    
    private func setUpTableView() {
        
        VehicleTableViewCell.register(with: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(reloadTableData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
    }
    
    @objc private func reloadTableData() {
        
        checkForEmptyCars()
        filterCarResultsBy(type: currentType)
    }
    
    private func setUpButtons() {
        
        // Set up accessbility text
        exploreButton.accessibilityIdentifier = FilterManager.FilterType.explore
        sedanButton.accessibilityIdentifier = FilterManager.FilterType.sedan
        suvButton.accessibilityIdentifier = FilterManager.FilterType.suv
        superCarButton.accessibilityIdentifier = FilterManager.FilterType.superCar
        truckButton.accessibilityIdentifier = FilterManager.FilterType.truck
        coupeButton.accessibilityIdentifier = FilterManager.FilterType.coupe
        
        // Add all buttons to array
        filterButtons.append(exploreButton)
        filterButtons.append(sedanButton)
        filterButtons.append(suvButton)
        filterButtons.append(superCarButton)
        filterButtons.append(truckButton)
        filterButtons.append(coupeButton)
    }
    
    private func resetAllButtonStyles() {
        
        for button in filterButtons {
            
            if let titleLabel = button.titleLabel {
                
                titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }
        }
    }
    
    private func filterCarResultsBy(type: String) {
        
        FirebaseManager.shared.getAllCars {
            
            FirebaseManager.shared.allCars = FilterManager.shared.filterCarsBySetDates()
            FirebaseManager.shared.allCars = FilterManager.shared.filterCarsByType(type)
            FirebaseManager.shared.allCars = FilterManager.shared.filterCarsByPassengers()
            
            self.currentType = type
            self.tableView.reloadData()
            self.checkForEmptyCars()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    private func checkForEmptyCars() {
        
        emptyFilterLabel.isHidden = !FirebaseManager.shared.allCars.isEmpty
    }
    
    @IBAction private func didTapFilterButton(_ sender: Any) {
        
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        filterViewController.modalPresentationStyle = .fullScreen
        present(filterViewController, animated: true) {}
    }
    
    @IBAction func didTapCarTypeFilterButton(sender: AnyObject) {
        
        guard let button = sender as? UIButton else { return }
        
        resetAllButtonStyles()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        filterCarResultsBy(type: button.accessibilityIdentifier ?? "")
    }
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FirebaseManager.shared.allCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let car = FirebaseManager.shared.allCars[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleTableViewCell.identifier)
            as? VehicleTableViewCell else {
                
                fatalError("cellForRowAt error")
        }
        
        cell.configure(with: car)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedCarVC = DetailedViewController()
        detailedCarVC.delegate = self
        detailedCarVC.modalPresentationStyle = .overFullScreen
        detailedCarVC.car = FirebaseManager.shared.allCars[indexPath.row]
        
        self.present(detailedCarVC, animated: true) {}
    }
}

extension ExploreViewController: FilterViewControllerDelegate, DetailedViewControllerDelegate {
    
    func didApplyFilter() {
        
        reloadTableData()
    }
    
    func didTapClose() {
        
        reloadTableData()
    }
    
    func didUpdateBooking() {}
}
