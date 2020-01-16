//
//  ViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-10.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        setUpElements()
        
        // Keep the user logged in
        if Auth.auth().currentUser != nil {
            
            let homeViewController = HomeViewController()
            navigationController?.pushViewController(homeViewController, animated: false)
        }
    }
    
    func setUpElements() {
        
        Utilities.styleWelcomeLabel(welcomeLabel)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(signUpButton)
        
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let signUpViewController = SignUpViewController()
        //self.present(signUpViewController, animated: true, completion: nil)
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
}

