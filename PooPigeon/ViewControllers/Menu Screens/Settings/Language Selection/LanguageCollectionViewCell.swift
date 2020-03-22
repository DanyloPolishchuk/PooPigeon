//
//  LanguageCollectionViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 22.03.2020.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import UIKit

class LanguageCollectionViewCell: UICollectionViewCell {
    
    var language: Language?
    weak var languageSelectionDelegate: LanguageSelectionProtocol?
    
    @IBOutlet weak var languageButton: UIButton!
    
    func displayContent(language: Language) {
        self.language = language
        switch language {
        case .Ukrainian:
            languageButton.setImage(UIImage(named: "ukrainianButtonNormal"), for: .normal)
            languageButton.setImage(UIImage(named: "ukrainianButtonPressed"), for: .highlighted)
        case .English:
            languageButton.setImage(UIImage(named: "britishButtonNormal"), for: .normal)
            languageButton.setImage(UIImage(named: "britishButtonPressed"), for: .highlighted)
        case .Russian:
            languageButton.setImage(UIImage(named: "russianButtonNormal"), for: .normal)
            languageButton.setImage(UIImage(named: "russianButtonPressed"), for: .highlighted)
        default:
            break
        }
    }
    
    @IBAction func selectLanguage(_ sender: UIButton) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        guard let language = self.language else {return}
        Settings.shared.changeLanguageTo(language: language)
        languageSelectionDelegate?.languageSelected()
    }
    
}
