//
//  HomeViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-29.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let exploreViewController = ExploreViewController()
        
        let exploreTabItem = UITabBarItem(
            title: "Explore",
            image: nil,
            tag: 0)
        
        exploreViewController.tabBarItem = exploreTabItem
        
        let garageViewController = GarageViewController()
        
        let garageTabItem = UITabBarItem(
            title: "Garage",
            image: nil,
            tag: 1)
        
        garageViewController.tabBarItem = garageTabItem
        
        let profileViewController = ProfileViewController()
        
        let profileTabItem = UITabBarItem(
            title: "Profile",
            image: nil,
            tag: 2)
        
        profileViewController.tabBarItem = profileTabItem
        
        let tabBarList = [exploreViewController,
                          garageViewController,
                          profileViewController]
        
        tabBar.tintColor = .white
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        
        viewControllers = tabBarList
    }
}
