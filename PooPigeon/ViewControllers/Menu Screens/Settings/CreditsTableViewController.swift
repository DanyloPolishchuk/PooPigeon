//
//  CreditsTableViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 2/5/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class CreditsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if indexPath.row == 0 {
                return 100
            }
            if indexPath.row == 1 {
                return 150
            }
        case .pad:
            if indexPath.row == 0 {
                return 200
            }
            if indexPath.row == 1 {
                return 300
            }
        default:
            return 0
        }
        return 0
    }

}
