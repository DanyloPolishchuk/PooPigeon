//
//  IAPProducts.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/10/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation

struct IAPProducts {
    
    private static let productIdentifiersDictionary = Bundle.main.object(forInfoDictionaryKey: "IAP Product Identifiers") as! [String : String]

    static let removeAdsIdentifier          = productIdentifiersDictionary["RemoveAds"] as! String
    static let unlockAllIdentifier          = productIdentifiersDictionary["UnlockAll"] as! String
    static let unlockAllBirdsIdentifier     = productIdentifiersDictionary["UnlockAllBirds"] as! String
    static let unlockAllLevelsIdentifier    = productIdentifiersDictionary["UnlockAllLevels"] as! String

    private static let productIdentifiers: Set<ProductIdentifier> = [
        IAPProducts.removeAdsIdentifier,
        IAPProducts.unlockAllIdentifier,
        IAPProducts.unlockAllBirdsIdentifier,
        IAPProducts.unlockAllLevelsIdentifier
    ]
    
    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
}
