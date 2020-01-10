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

protocol WallpaperActionsProtocol: class {
    func shareImage(image: UIImage)
    func showRewardedAdToUnlockWallpaper(wallpaper: Wallpaper)
}

protocol SettingsScreensPresentationProtocol: class {
    func likeApplication()
    func shareApplication()
    func showCredits()
    func showContactInfo()
    func restorePurchases()
    func removeAds()
}

protocol ShopPurchasesProtocol: class {
    func unlockAllBirds()
    func unlockAllLevels()
}
