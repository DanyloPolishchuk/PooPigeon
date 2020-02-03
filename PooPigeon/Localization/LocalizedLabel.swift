//
//  LocalizedLabel.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 2/3/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

@IBDesignable class LocalizedLabel: UILabel {
    
    @IBInspectable var tableName: String? {
        didSet{
            update()
        }
    }
    
    func update(){
        guard let tableName = self.tableName else {return}
        self.text = LocalizationHelper.defaultLocalizer.stringForKey(key: tableName)
    }
    
}
