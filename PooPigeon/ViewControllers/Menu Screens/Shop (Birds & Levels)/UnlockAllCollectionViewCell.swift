//
//  UnlockAllCollectionViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/10/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class UnlockAllCollectionViewCell: UICollectionViewCell {
    
    var type: ShopButtonType?
    weak var shopPurchasesDelegate: ShopPurchasesProtocol?
    
    @IBOutlet weak var unlockButton: UIButton!
    
    override func awakeFromNib() {
        unlockButton.setBackgroundImage(UIImage(named: "bigButtonImagePressed"), for: .highlighted)
    }
    
    @IBAction func unlockAction(_ sender: UIButton) {
        if type == .UnlockAllBirds{
            shopPurchasesDelegate?.unlockAllBirds()
        }else{
            shopPurchasesDelegate?.unlockAllLevels()
        }
    }
    
}
