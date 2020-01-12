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

    // MARK: - Header Properties
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBOutlet weak var user: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTableView: UITableView!
    
    private var enabledButton: UIButton!
    
    private var infoContent: [Info] = []
    private var paymentContent: [Payment] = []
    private var helpContent: [Help] = []

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Utilities.styleProfilePicture(profilePicture, pictureButton)
        Utilities.styleTabButton(infoButton, "Info")
        Utilities.styleTabButton(paymentButton, "Payment")
        Utilities.styleTabButton(helpButton, "Help")

        setUpUserName()
        setUpHeaderView()
        enableButton(button: infoButton)
        populateInfoArray()
        populatePaymentArray()
        populateHelpArray()
        setUpContentView()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setUpUserName() {
        if let userID = Auth.auth().currentUser {
            FirebaseManager.shared.getUserDataFor(userID.uid, key: "firstName") { (firstName) in
                self.user.text = firstName + " "
            }
            FirebaseManager.shared.getUserDataFor(userID.uid, key: "lastName") { (lastName) in
                self.user.text?.append(lastName)
            }
        }
        
        user.textAlignment = .center
        user.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        user.textColor = .white
    }
    
    private func setUpHeaderView() {
        
        //Create header container
        view.addSubview(headerView)
        headerView.backgroundColor = .black
        headerView.clipsToBounds = false
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
    
        //Add profile Picture
        headerView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        profilePicture.anchor(top: headerView.topAnchor, paddingTop: 78, width: 120, height: 120)
        
        view.addSubview(pictureButton)
        pictureButton.anchor(top: headerView.topAnchor, left: profilePicture.rightAnchor, paddingTop: 80, paddingLeft: -24, width: 30, height: 30)
        
        //Add user's Name
        headerView.addSubview(user)
        user.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        user.anchor(top: profilePicture.bottomAnchor, paddingTop: 25)
        
        //Add tab bar buttons
        headerView.addSubview(infoButton)
        infoButton.anchor(left: headerView.leftAnchor, bottom: headerView.bottomAnchor, width: view.frame.size.width/3, height: 40)
        
        headerView.addSubview(paymentButton)
        paymentButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        paymentButton.anchor(bottom: headerView.bottomAnchor, width: view.frame.size.width/3, height: 40)
        
        headerView.addSubview(helpButton)
        helpButton.anchor(bottom: headerView.bottomAnchor, right: headerView.rightAnchor, width: view.frame.size.width/3, height: 40)
        
    }
    
    private func populateInfoArray() {
        
        if let userID = Auth.auth().currentUser {

            FirebaseManager.shared.getUserDataFor(userID.uid, key: "email") { (data) in
                let field = Info.initialize(image: #imageLiteral(resourceName: "envelope"), title: "Email", content: data, buttonImage: #imageLiteral(resourceName: "pencil-edit-button"), type: .email)
                
                self.infoContent.insert(field, at: 0)
                self.contentTableView.reloadData()
            }
            FirebaseManager.shared.getUserDataFor(userID.uid, key: "address") { (data) in
                let field = Info.initialize(image: #imageLiteral(resourceName: "home"), title: "Address", content: data, buttonImage: #imageLiteral(resourceName: "home"), type: .address)
                
                self.infoContent.insert(field, at: 1)
                self.contentTableView.reloadData()
            }
            FirebaseManager.shared.getUserDataFor(userID.uid, key: "phoneNumber") { (data) in
                let field = Info.initialize(image: #imageLiteral(resourceName: "telephone"), title: "Phone Number", content: data, buttonImage: #imageLiteral(resourceName: "pencil-edit-button"), type: .phoneNumber)
                self.infoContent.insert(field, at: 2)
                self.contentTableView.reloadData()
            }
            
            let field4 = Info.initialize(image: #imageLiteral(resourceName: "lock"), title: "Password", content: "*******", buttonImage: #imageLiteral(resourceName: "pencil-edit-button"), type: .password)
            self.infoContent.append(field4)

        }
    }
    
    private func populatePaymentArray() {
        let field1 = Payment.initialize(type: Payment.paymentMethod.visa, content: "···· ···· ···· 1904", buttonImage: #imageLiteral(resourceName: "cross"))
        let field2 = Payment.initialize(type: Payment.paymentMethod.mastercard, content: "···· ···· ···· 2109", buttonImage: #imageLiteral(resourceName: "cross"))
        let field3 = Payment.initialize(type: Payment.paymentMethod.american, content: "···· ···· ···· 1304", buttonImage: #imageLiteral(resourceName: "cross"))
        
        self.paymentContent.append(field1)
        self.paymentContent.append(field2)
        self.paymentContent.append(field3)
        
    }
    
    private func populateHelpArray() {
        FirebaseManager.shared.getFAQs { (data) in
            if data.header == "Contact Information:" {
                data.contentDescription = data.contentDescription.replacingOccurrences(of: "_n ", with: "\n")
                self.helpContent.insert(data, at: 0)
            }
            else {
                self.helpContent.append(data)
            }
        }
    }
    
    private func setUpContentView() {
        view.addSubview(contentView)
        contentView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        contentView.addSubview(contentTableView)
        contentTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentTableView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        
        setUpTableView()
    }

    func setUpTableView() {
        
        InfoTableViewCell.register(with: contentTableView)
        PaymentTableViewCell.register(with: contentTableView)
        HelpTableViewCell.register(with: contentTableView)
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        contentTableView.separatorStyle = .none
        contentTableView.rowHeight = UITableView.automaticDimension
    }
    
    func enableButton(button: UIButton) {
        enabledButton = button
        enabledButton.backgroundColor = #colorLiteral(red: 0, green: 0.3550197875, blue: 0.8549019694, alpha: 1)
        
        if(enabledButton == infoButton) {
            paymentButton.backgroundColor = .black
            helpButton.backgroundColor = .black
        }
        else if(enabledButton == paymentButton) {
            infoButton.backgroundColor = .black
            helpButton.backgroundColor = .black
        }
        else {
            infoButton.backgroundColor = .black
            paymentButton.backgroundColor = .black
        }
        
    }
    // MARK: - Selectors

    @IBAction func infoTapped(_ sender: Any) {
        enableButton(button: infoButton)
        contentTableView.reloadData()
    }

    @IBAction func paymentTapped(_ sender: Any) {
        enableButton(button: paymentButton)
        contentTableView.reloadData()
    }

    @IBAction func helpTapped(_ sender: Any) {
        enableButton(button: helpButton)
        setUpTableView()
        contentTableView.reloadData()
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        dismiss(animated: true) {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        //Checks to see if top anchor exists
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(enabledButton == infoButton) {
            return infoContent.count
        }
        else if (enabledButton == paymentButton) {
            return paymentContent.count
        }
        else if (enabledButton == helpButton) {
            return helpContent.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(enabledButton == infoButton) {
            let info = infoContent[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier) as? InfoTableViewCell else {
                fatalError("cellForRowAt error")
            }
            
            cell.configureWith(Info: info)
            return cell
        }
        else if (enabledButton == paymentButton){
            let payment = paymentContent[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier:PaymentTableViewCell.identifier) as? PaymentTableViewCell else {
                fatalError("cellForRowAt error")
            }
            cell.configureWith(Payment: payment)
            contentTableView.rowHeight = 80
            return cell
        }
        else {
            let help = helpContent[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HelpTableViewCell.identifier) as? HelpTableViewCell else {
                fatalError("cellForRowAt error")
            }
            cell.configureWith(Help: help)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if enabledButton == infoButton {
            
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
        
        infoContent = []
        populateInfoArray()
        contentTableView.reloadData()
    }
}
