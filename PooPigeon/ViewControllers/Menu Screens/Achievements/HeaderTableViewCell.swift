//
//  HeaderTableViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/9/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerTextLabel: UILabel!
    
    func displayContent(headerText: String){
        self.headerTextLabel.text = headerText
    }

}
