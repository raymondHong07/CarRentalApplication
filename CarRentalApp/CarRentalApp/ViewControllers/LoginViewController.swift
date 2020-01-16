//
//  LoginViewController.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-10-15.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {


    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stackView.setNeedsLayout()
        stackView.layoutIfNeeded()
        
        setUpElements()
    }
    
    func setUpElements() {
        
        //Hide error label
        errorLabel.alpha = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0
        
        //Style text fields
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        
        //Style login button
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //Validate email and password
        
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (email.isEmpty || password.isEmpty) {
            self.displayError("Please enter your email and password.")
        }
        else {
            //Sign in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    //Could not sign in
                    self.displayError("Incorrect Email or Password")
                }
                else {
                    self.promptHomeScreen()
                }
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        let signUpViewController = SignUpViewController()
        navigationController?.popViewController(animated: true)
        //navigationController?.popToViewController(signUpViewController, animated: true)
        navigationController?.pushViewController(signUpViewController, animated: true)
        
    }
    
    
    func displayError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func promptHomeScreen() {
        
        let homeVC = HomeViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
