//
//  ProfileViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-29.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTableView: UITableView!
    
    private var enabledButton: UIButton!
    
    private var infoContent: [Info] = []
    private var paymentContent: [Payment] = []
    private var helpContent: [Help] = []
    
    private var profileButtons: [UIButton] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        setUpView()
        setUpUserName()
        setUpProfileButtonsArray()
        setUpTableView()
        
        populateInfoContent()
        populatePaymentContent()
        populateHelpContent()
        
        enable(profileButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setUpProfileButtonsArray() {
        
        profileButtons.append(profileButton)
        profileButtons.append(paymentButton)
        profileButtons.append(helpButton)
    }
    
    private func setUpView() {
        
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 3
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.layer.cornerRadius = 120/2
        
        pictureButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        pictureButton.tintColor = .white
        pictureButton.backgroundColor = #colorLiteral(red: 0, green: 0.3550197875, blue: 0.8549019694, alpha: 1)
        pictureButton.layer.cornerRadius = 30/2
        
        styleTabButton(profileButton, title: "Profile")
        styleTabButton(paymentButton, title: "Payment")
        styleTabButton(helpButton, title: "Help")
    }
    
    private func styleTabButton(_ button: UIButton, title: String) {
        
        // TO DO: Create UIButton extenion with decorate()
        button.layer.cornerRadius = 4
        button.backgroundColor = .black
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    private func setUpUserName() {
        
        let currentUser = FirebaseManager.shared.currentUser
        
        userLabel.text = currentUser.firstName + " " + currentUser.lastName
        userLabel.textAlignment = .center
        userLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        userLabel.textColor = .white
    }
    
    
    private func populateInfoContent() {
        
        let currentUser = FirebaseManager.shared.currentUser
        
        let email = Info.initialize(image: #imageLiteral(resourceName: "envelope"),
                                    title: "Email",
                                    content: currentUser.email,
                                    buttonImage: #imageLiteral(resourceName: "pencil-edit-button"),
                                    type: .email)
        
        let address = Info.initialize(image: #imageLiteral(resourceName: "home"),
                                      title: "Address",
                                      content: currentUser.address,
                                      buttonImage: #imageLiteral(resourceName: "home"),
                                      type: .address)
        
        let phoneNumber = Info.initialize(image: #imageLiteral(resourceName: "telephone"),
                                          title: "Phone Number",
                                          content: currentUser.phoneNumber,
                                          buttonImage: #imageLiteral(resourceName: "pencil-edit-button"),
                                          type: .phoneNumber)
        
        let password = Info.initialize(image: #imageLiteral(resourceName: "lock"),
                                       title: "Password",
                                       content: "*******",
                                       buttonImage: #imageLiteral(resourceName: "pencil-edit-button"),
                                       type: .password)
        
        infoContent.append(email)
        infoContent.append(address)
        infoContent.append(phoneNumber)
        infoContent.append(password)
        contentTableView.reloadData()
    }
    
    private func populatePaymentContent() {
        
        let dummyPayment1 = Payment.initialize(type: Payment.paymentMethod.visa, content: "···· ···· ···· 1904", buttonImage: #imageLiteral(resourceName: "cross"))
        let dummyPayment2 = Payment.initialize(type: Payment.paymentMethod.mastercard, content: "···· ···· ···· 2109", buttonImage: #imageLiteral(resourceName: "cross"))
        let dummyPayment3 = Payment.initialize(type: Payment.paymentMethod.american, content: "···· ···· ···· 1304", buttonImage: #imageLiteral(resourceName: "cross"))
        
        paymentContent.append(dummyPayment1)
        paymentContent.append(dummyPayment2)
        paymentContent.append(dummyPayment3)
    }
    
    private func populateHelpContent() {
        
        FirebaseManager.shared.getFAQs { (data) in
            
            if data.header == "Contact Information:" {
                
                data.contentDescription = data.contentDescription.replacingOccurrences(of: "_n ", with: "\n")
                self.helpContent.insert(data, at: 0)
                
            } else {
                
                self.helpContent.append(data)
            }
        }
    }

    private func setUpTableView() {
        
        InfoTableViewCell.register(with: contentTableView)
        PaymentTableViewCell.register(with: contentTableView)
        HelpTableViewCell.register(with: contentTableView)
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        contentTableView.separatorStyle = .none
        contentTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func resetAllButtonsStyles() {
        
        for button in profileButtons {
            
            button.backgroundColor = .black
        }
    }
    
    private func enable(_ button: UIButton) {
        
        resetAllButtonsStyles()
        button.backgroundColor = #colorLiteral(red: 0, green: 0.3550197875, blue: 0.8549019694, alpha: 1)
        enabledButton = button
    }
    
    
    @IBAction private func profileCategoryButtonTapped(_ sender: AnyObject) {
        
        guard let button = sender as? UIButton else {
            return
        }

        enable(button)
        contentTableView.reloadData()
    }

    
    @IBAction func signOutButtonTapped(_ sender: Any) {
                
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if enabledButton == profileButton {
            
            return infoContent.count
            
        } else if enabledButton == paymentButton {
            
            return paymentContent.count
            
        } else {
            
            return helpContent.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if enabledButton == profileButton {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier) as? InfoTableViewCell else {
                fatalError("cellForRowAt error")
            }
            
            cell.configure(with: infoContent[indexPath.row])
            return cell
        }
        else if enabledButton == paymentButton {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.identifier) as? PaymentTableViewCell else {
                fatalError("cellForRowAt error")
            }
            
            cell.configure(with: paymentContent[indexPath.row])
            return cell
        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpTableViewCell.identifier) as? HelpTableViewCell else {
                fatalError("cellForRowAt error")
            }
            
            cell.configure(with: helpContent[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if enabledButton == profileButton {
            
            let profileEditViewController = ProfileEditViewController()
            profileEditViewController.modalPresentationStyle = .fullScreen
            profileEditViewController.header = infoContent[indexPath.row].header
            profileEditViewController.content = infoContent[indexPath.row].content
            profileEditViewController.profileFieldType = infoContent[indexPath.row].type
            profileEditViewController.delegate = self
            
            present(profileEditViewController, animated: true) {}
        }
    }
}

extension ProfileViewController: ProfileEditViewControllerDelegate {
    
    func didUpdateProfile() {
        
        FirebaseManager.shared.getUser {
           
            self.infoContent = []
            self.populateInfoContent()
            self.contentTableView.reloadData()
        }
    }
}
