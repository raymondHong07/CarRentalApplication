//
//  ProfileEditViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-11-25.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

protocol ProfileEditViewControllerDelegate: class {
    
    func didUpdateProfile()
}

public enum ProfileField: String {
    
    case firstName = "firstName"
    case lastName = "lastName"
    case address = "address"
    case email = "email"
    case password = "password"
    case phoneNumber = "phoneNumber"
}

class ProfileEditViewController: UIViewController {
    
    @IBOutlet private weak var updateButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var profileEditTextField: UITextField!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var currentPasswordLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var activityLoader: UIActivityIndicatorView!
    
    var profileFieldType: ProfileField = .firstName
    var header = ""
    var content = ""
    var delegate: ProfileEditViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        setUpTextField()
    }
    
    private func setUpView() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        headerLabel.text = ("New \(header)")
        profileEditTextField.text = content
        
        // Alter view based on field type
        if (profileFieldType == .email || profileFieldType == .password) {
            
            currentPasswordLabel.isHidden = false
            passwordTextField.isHidden = false
            
            if profileFieldType == .password {
                
                profileEditTextField.text = ""
            }
        }
    }
    
    private func setUpTextField() {
        
        profileEditTextField.autocorrectionType = .no
        profileEditTextField.becomeFirstResponder()
        passwordTextField.autocorrectionType = .no
    }
    
    private func presentError() {
        
        let errorAlert = UIAlertController(title: "Error",
                                             message: "Please ensure the information entered is valid and try again",
                                             preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "Okay",
                                             style: .default,
                                             handler: { (action: UIAlertAction!) in
        }))
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func updateBasicUserDataFor(key: String, with value: String) {
        
        FirebaseManager.shared.updateUserDataFor(key: key, newValue: value)
        
        dismiss(animated: true) {
            self.delegate?.didUpdateProfile()
        }
    }
    
    private func handleAdvancedProfileUpdateUIFlow(with success: Bool) {
        
        activityLoader.isHidden = true
        
        if success {
            
            dismiss(animated: true) {
                self.delegate?.didUpdateProfile()
            }
            
        } else {
            
            presentError()
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.10) {
            
            self.updateButtonBottomConstraint.constant = 291
        }
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true) {}
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        activityLoader.startAnimating()
        activityLoader.isHidden = false
        
        switch profileFieldType {
            
        case .firstName,
             .lastName,
             .address,
             .phoneNumber:
    
            if let newValue = profileEditTextField.text {
                
                updateBasicUserDataFor(key: profileFieldType.rawValue, with: newValue)
            }
            
        case .email:
            
            if let newEmail = profileEditTextField.text,
                let currentPassword = passwordTextField.text {
                
                FirebaseManager.shared.updateUserEmailWith(newEmail, currentPassword: currentPassword) { (success) in
                    
                    self.handleAdvancedProfileUpdateUIFlow(with: success)
                }
            }
            
        case .password:
            
            if let newPassword = profileEditTextField.text,
                let currentPassword = passwordTextField.text {
                
                FirebaseManager.shared.updateUserPasswordWith(newPassword, currentPassword: currentPassword) { (success) in
                    
                    self.handleAdvancedProfileUpdateUIFlow(with: success)
                }
            }
        }
    }
}
