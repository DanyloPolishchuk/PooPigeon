//
//  ImageLibraryAccessAlertViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/5/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class ImageLibraryAccessAlertViewController: UIViewController {
    
    weak var achievementsViewController: AchievementsViewController!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup localized description label text
        // setup localized button label text
        settingsButton.setBackgroundImage(UIImage(named: "bigButtonImagePressed"), for: .highlighted)
    }

    @IBAction func settingsAction(_ sender: UIButton) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL,
                                      options: [:],
                                      completionHandler: nil)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        achievementsViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
    
}
