//
//  CreditsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/20/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    weak var settingsViewController: SettingsViewController!

    @IBOutlet weak var creditsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add localized text to creditsLabel
    }
    
    @IBAction func backAction(_ sender: Any) {
        settingsViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
    
}
