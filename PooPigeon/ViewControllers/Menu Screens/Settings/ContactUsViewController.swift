//
//  ContactUsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/19/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // possible updgradable features:
    // 1. make email label copiable / add "copy" button so user doesn't have to remeber contact info
    // 2. make email label a button that'd lead to "Mail" app with opened new letter template
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func setupLabels(){
        // replace with localized string
        contactUsLabel.text = "Contact Us"
        // replace with actual contact email once one is done
        emailLabel.text = "PooPigeonExample@gmail.com"
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
