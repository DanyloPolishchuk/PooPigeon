//
//  GetAllViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 2/1/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class GetAllViewController: UIViewController {

    weak var shopViewController: ShopViewController!
    
    @IBOutlet weak var getAllLabel: UILabel!
    @IBOutlet weak var getAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllButton.setBackgroundImage(UIImage(named: "bigButtonImagePressed"), for: .highlighted)
        // setup label & button font & localization
    }
    
    @IBAction func getAllAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.shopViewController.unhideBannerView()
            self.shopViewController.buyUnlockAll()
            self.dismiss(animated: true)
        }
    }
    @IBAction func backAction(_ sender: Any) {
        shopViewController.unhideBannerView()
        self.dismiss(animated: true)
    }
    
}
