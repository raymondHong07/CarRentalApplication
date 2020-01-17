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

    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        errorLabel.isHidden = true
    }
    
    private func setUpElements() {

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        Utilities.styleFilledButton(loginButton)
    }
    
    private func displayError(_ errorText: String) {
        
        errorLabel.text = errorText
        errorLabel.isHidden = false
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            if (email.isEmpty || password.isEmpty) {
                
                displayError("Please enter your email and password.")
                return
            }
            
            //Sign in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {

                    self.displayError("Incorrect Email or Password")
                    
                } else {
                    
                    self.proceedToHomeScreen()
                }
            }
        }
    }
    
    private func proceedToHomeScreen() {
        
        let homeVC = HomeViewController()
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // FUTURE TO DO:
        // Implement signUpViewController

        let underConstructionAlert = UIAlertController(title: "Under Constructuon",
                                             message: "Please temporarily use:\nemail: test@gmail.com\npw: test123",
                                             preferredStyle: .alert)

        underConstructionAlert.addAction(UIAlertAction(title: "Okay",
                                             style: .default,
                                             handler: { (action: UIAlertAction!) in
        }))

        present(underConstructionAlert, animated: true, completion: nil)
    }
    
}

extension WelcomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == emailTextField {
         
            passwordTextField.becomeFirstResponder()
        }
        
        return true
    }
    
}

