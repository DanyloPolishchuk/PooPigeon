//
//  TutorialViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/21/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    weak var mainMenuViewController: MainMenuViewController!
    
    @IBOutlet weak var shouldShowSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isTutorialSupposedToBeShown = Settings.shared.isTutorialSupposedToBeShown
        shouldShowSwitch.isOn = !isTutorialSupposedToBeShown
        shouldShowSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchValueChanged(_ uiSwitch: UISwitch){
        if uiSwitch.isOn{
            Settings.shared.isTutorialSupposedToBeShown = false
        }else{
            Settings.shared.isTutorialSupposedToBeShown = true
        }
        Settings.shared.save()
    }
    
    @IBAction func backAction(_ sender: Any) {
        mainMenuViewController.unhideBannerView()
        mainMenuViewController.setupTutorialButton()
        self.dismiss(animated: true)
    }
    
}
