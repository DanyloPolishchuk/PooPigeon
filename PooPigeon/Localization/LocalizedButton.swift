//
//  LocalizedButton.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 2/3/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

@IBDesignable class LocalizedButton: UIButton {

    @IBInspectable var tableName: String? {
        didSet{
            update()
        }
    }
    
    func update(){
        guard let tableName = tableName else {return}
        self.setTitle(LocalizationHelper.defaultLocalizer.stringForKey(key: tableName), for: UIControl.State.normal)
    }

}
