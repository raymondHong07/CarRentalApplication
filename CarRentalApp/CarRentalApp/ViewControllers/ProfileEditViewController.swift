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

public enum ProfileField {
    
    case firstName
    case lastName
    case address
    case email
    case password
    case phoneNumber
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        headerLabel.text = ("New \(header)")
        profileEditTextField.text = content
        
        if (profileFieldType == .email || profileFieldType == .password) {
            
            currentPasswordLabel.isHidden = false
            passwordTextField.isHidden = false
            
            if profileFieldType == .password {
                
                profileEditTextField.text = ""
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        setUpTextField()
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

    @objc func keyboardWillShow(notification: NSNotification) {
        
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
        UIView.animate(withDuration: 0.10) {
            
            self.updateButtonBottomConstraint.constant = 291
        }
//        }
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true) {}
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
        activityLoader.startAnimating()
        activityLoader.isHidden = false
        
        switch profileFieldType {
            
        case .firstName:
            
            if let newFirstName = profileEditTextField.text {
                
                FirebaseManager.shared.updateUserDataFor(key: "firstName", newValue: newFirstName)
                
                dismiss(animated: true) {
                    
                    self.delegate?.didUpdateProfile()
                }
            }
            
        case .lastName:
            
            if let newLastName = profileEditTextField.text {
                
                FirebaseManager.shared.updateUserDataFor(key: "lastName", newValue: newLastName)
                
                dismiss(animated: true) {
                    
                    self.delegate?.didUpdateProfile()
                }
            }
            
        case .email:
            
            if let newEmail = profileEditTextField.text,
                let currentPassword = passwordTextField.text {
                
                FirebaseManager.shared.updateUserEmailWith(newEmail, currentPassword: currentPassword) { (success) in
                    
                    self.activityLoader.isHidden = true
                    
                    if success {
                        
                        self.dismiss(animated: true) {
                            
                            self.delegate?.didUpdateProfile()
                        }
                        
                    } else {
                        
                        self.presentError()
                    }
                }
            }
            
        case .password:
            
            if let newPassword = profileEditTextField.text,
                let currentPassword = passwordTextField.text {
                
                FirebaseManager.shared.updateUserPasswordWith(newPassword, currentPassword: currentPassword) { (success) in
                    
                    self.activityLoader.isHidden = true
                    
                    if success {
                        
                        self.dismiss(animated: true) {
                            
                            self.delegate?.didUpdateProfile()
                        }
                        
                    } else {
                        
                        self.presentError()
                    }
                }
            }
            
        case .address:
            
            if let newAddress = profileEditTextField.text {
                
                FirebaseManager.shared.updateUserDataFor(key: "address", newValue: newAddress)
                
                dismiss(animated: true) {
                    
                    self.delegate?.didUpdateProfile()
                }
            }
            
        case .phoneNumber:
            
            if let newPhoneNumber = profileEditTextField.text {
                
                FirebaseManager.shared.updateUserDataFor(key: "phoneNumber", newValue: newPhoneNumber)
                
                dismiss(animated: true) {
                    
                    self.delegate?.didUpdateProfile()
                }
            }
        }
    }
}
