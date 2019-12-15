//
//  Protocols.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

protocol CustomNodeEvents {
    func didMoveToScene()
}
protocol InteractiveNode {
    func interact()
}

protocol UIActivityShareProtocol: class {
    func shareImage(image: UIImage)
}

protocol SettingsScreensPresentationProtocol: class {
    func likeApplication()
    func shareApplication()
    func showCredits()
    func showContactInfo()
    func restorePurchases()
    func removeAdds()
}
