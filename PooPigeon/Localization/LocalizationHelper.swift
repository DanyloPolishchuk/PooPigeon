//
//  LocalizationHelper.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 2/3/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class LocalizationHelper: NSObject {
    
    static let defaultLocalizer = LocalizationHelper()
    
    var appBundle = Bundle.main
    
    func setSelectedLanguage(lang: String) {
        guard let langPath = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            appBundle = Bundle.main
            return
        }
        appBundle = Bundle(path: langPath)!
    }
    
    func stringForKey(key: String) -> String {
        return appBundle.localizedString(forKey: key, value: "", table: nil)
    }
    
}

// Usage
// let defaultLocalizer = AMPLocalizeUtils.defaultLocalizer

// Language change
// defaultLocalizer.setSelectedLanguage(lang: "en")

// String get
// lbl.text! =  defaultLocalizer.stringForKey(key: "Red")

