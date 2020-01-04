//
//  AdsCantLoadAlertViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/4/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class AdsCantLoadAlertViewController: UIViewController {

    weak var achievementsViewController: AchievementsViewController!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(back), name: .rewardedAdDidLoadSuccessfully, object: nil)
        // setup localized string for label
    }
    
    @objc func back(){
        achievementsViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        back()
    }

}
