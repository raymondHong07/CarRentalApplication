//
//  ConfirmationViewController.swift
//  CarRentalApp
//
//  Created by Raymond Hong on 2019-10-28.
//  Copyright © 2019 R&R. All rights reserved.
//

import UIKit

protocol ConfirmationViewControllerDelegate: class {
    
    func didConfirm()
}

public enum OrderStatus {
    
    case free
    case rented
}

class ConfirmationViewController: UIViewController {
    
    @IBOutlet public weak var descriptionTextView: UITextView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    var delegate: ConfirmationViewControllerDelegate?
    public var status: OrderStatus = .free
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpBlurredView()
        
        if status == .rented {
            
            setUpRentedText()
        }
    }
    
    private func setUpRentedText() {
        
        titleLabel.text = "Error occured during order!"
        descriptionTextView.text = "We apologize, but it looks like the vehicle you wanted to rent may have just been rented by another user. Please select another range of dates if you would still like to rent this vehicle"
    }
    
    private func setUpBlurredView() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundView.addSubview(blurEffectView)
    }

    @IBAction private func okayButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.didConfirm()
        }
    }
}
