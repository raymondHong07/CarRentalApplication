//
//  SignUpViewController.swift
//  CarRentalApp
//
//  Created by Roli Jule on 2019-10-15.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var provinceField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
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
        
        //Hides the error label
        errorLabel.alpha = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 0

        //Sytles the registration fields
        Utilities.styleTextField(firstNameField)
        Utilities.styleTextField(lastNameField)
        Utilities.styleTextField(phoneNumberField)
        Utilities.styleTextField(addressField)
        Utilities.styleTextField(cityField)
        Utilities.styleTextField(provinceField)
        Utilities.styleTextField(postalCodeField)
        Utilities.styleTextField(emailField)
        Utilities.styleTextField(passwordField)
        phoneNumberField.delegate = self
        
        //Styles the sign up button
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        
        //Create a new user
        if error != nil {
            displayError(error!)
        }
        else {
            //Hides the error label
            errorLabel.alpha = 0
            //Initialize data
            let firstName = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    //Signifies there was an error creating the user
                    self.displayError(err!.localizedDescription)
                }
                else {
                    //Store the first name and last name
                    //Allows us to use database to call methods to add data to database
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    
                    let newUser = Auth.auth().currentUser
                    
                    ref.child("users").child(newUser!.uid).setValue(["firstName": firstName,
                                                                     "lastName": lastName,
                                                                     "email": email,
                                                                     "phoneNumber": phoneNumber,
                                                                     "address": "",
                                                                     "profilePicture": ""])
                    
                    
                    //Prompt user to home screen
                    self.promptLogInScreen()
                    
                }
            }
        }
        
        return
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let loginViewController = LoginViewController()
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
    
    func validateFields() -> String? {
        
        //Check if all fields have been filled in
        if firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all required fields*"
        }
        
        if phoneNumberField.text?.count != 10 {
            return "Please provide a valid phone number (XXX)-XXX-XXXX"
        }
        
        
        //Check if password meets the required fields
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(password) == false {
            
            return "Please meet password requirements"
        }
        
        return nil
    }
    
    func displayError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func promptLogInScreen() {
        
        let LogInVC = LoginViewController()
        
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(LogInVC, animated: true)
    }
    
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
    
        return allowedCharacterSet.isSuperset(of: typedCharacterSet) && newLength <= 10
    }
    
}

