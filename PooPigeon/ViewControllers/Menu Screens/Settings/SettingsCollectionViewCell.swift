//
//  SettingsCollectionViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/5/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    var buttonType: SettingButtonType?
    weak var settingsScreenPresentationDelegate: SettingsScreensPresentationProtocol?
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var settingsDescriptionLabel: UILabel!
    
    func displayContent(buttonType: SettingButtonType){
        self.buttonType = buttonType
        
        setupCellLabel()
        updateCellButtonImage()
    }
    
    func setupCellLabel(){
        guard let buttonType = self.buttonType else {return}
        switch buttonType {
            
        case .Sound:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Sound")
            
        case .Music:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Music")
            
        case .Language:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Language")
            
        case .Like:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Like")
            
        case .Share:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Share")
            
        case .Review:
            // probably'll be deleted
            break
        case .Credits:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Credits")
            
        case .ContantInfo:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Contact Info")
            
        case .RestorePurchases:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Restore Purchases")
            
        case .RemoveAdds:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "Remove Ads")
            
        case .UIhand:
            settingsDescriptionLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: "UI Hand")
            
        }
    }
    
    /// updates current cell buttonImage
    func updateCellButtonImage(){
        guard let buttonType = self.buttonType else {return}
        switch buttonType {
            
        case .Sound:
            let isSoundEffectsEnabled = Settings.shared.isSoundEffectsEnabled
            settingsButton.setImage(UIImage(named: isSoundEffectsEnabled ? "sfxOnButtonNormal" : "sfxOffButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: isSoundEffectsEnabled ? "sfxOnButtonPressed" : "sfxOffButtonPressed"), for: .highlighted)
            
        case .Music:
            let isMusicEnabled = Settings.shared.isMusicEnabled
            settingsButton.setImage(UIImage(named: isMusicEnabled ? "musicOnButtonNormal" : "musicOffButtonNormal" ), for: .normal)
            settingsButton.setImage(UIImage(named: isMusicEnabled ? "musicOnButtonPressed" : "musicOffButtonPressed"), for: .highlighted)
            
        case .Language:
            let currentLanguage = Settings.shared.getLanguage()
            switch currentLanguage{
            case .Ukrainian:
                settingsButton.setImage(UIImage(named: "ukrainianButtonNormal"), for: .normal)
                settingsButton.setImage(UIImage(named: "ukrainianButtonPressed"), for: .highlighted)
            case .English:
                settingsButton.setImage(UIImage(named: "britishButtonNormal"), for: .normal)
                settingsButton.setImage(UIImage(named: "britishButtonPressed"), for: .highlighted)
            case .Russian:
                settingsButton.setImage(UIImage(named: "russianButtonNormal"), for: .normal)
                settingsButton.setImage(UIImage(named: "russianButtonPressed"), for: .highlighted)
            }
            
        case .Like:
            settingsButton.setImage(UIImage(named: "likeButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: "likeButtonPressed"), for: .highlighted)
            
        case .Share:
            settingsButton.setImage(UIImage(named: "shareButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: "shareButtonPressed"), for: .highlighted)
            
        case .Review:
            // probably'll be deleted
            break
        case .Credits:
            settingsButton.setImage(UIImage(named: "creditsButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: "creditsButtonPressed"), for: .highlighted)
            
        case .ContantInfo:
            settingsButton.setImage(UIImage(named: "contactInfoButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: "contactInfoButtonPressed"), for: .highlighted)
            
        case .RestorePurchases:
            settingsButton.setImage(UIImage(named: "restorePurchasesButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: "restorePurchasesButtonPressed"), for: .highlighted)
            
        case .RemoveAdds:
            settingsButton.setImage(UIImage(named: "removeAdsButtonNormal"), for: .normal)
            settingsButton.setImage(UIImage(named: "removeAdsButtonPressed"), for: .highlighted)
            
        case .UIhand:
            let isLeftHandedUI = Settings.shared.isLeftHandedUI
            settingsButton.setImage(UIImage(named: isLeftHandedUI ? "leftHandUIButtonNormal" : "rightHandUIButtonNormal" ), for: .normal)
            settingsButton.setImage(UIImage(named: isLeftHandedUI ? "leftHandUIButtonPressed" : "rightHandUIButtonPressed"), for: .highlighted)
            
        }
        
    }
    
    @IBAction func performAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        
        guard let buttonType = self.buttonType else {return}
        switch buttonType {
        
        case .Sound:
            let isSFXEnabled = Settings.shared.isSoundEffectsEnabled
            Settings.shared.isSoundEffectsEnabled = !isSFXEnabled
            Settings.shared.save()
            updateCellButtonImage()
            NotificationCenter.default.post(name: isSFXEnabled ? .turnSFXOff : .turnSFXOn , object: nil)
            
        case .Music:
            let isMusicEnabled = Settings.shared.isMusicEnabled
            Settings.shared.isMusicEnabled = !isMusicEnabled
            Settings.shared.save()
            updateCellButtonImage()
            NotificationCenter.default.post(name: isMusicEnabled ? .turnMusicOff : .turnMusicOn, object: nil)
            
        case .Language:
            let currentLanguage = Settings.shared.getLanguage()
            switch currentLanguage{
            case .English:
                Settings.shared.changeLanguageTo(language: .Ukrainian)
            case .Ukrainian:
                Settings.shared.changeLanguageTo(language: .Russian)
            case .Russian:
                Settings.shared.changeLanguageTo(language: .English)
            }
            updateCellButtonImage()
            NotificationCenter.default.post(name: .updateLanguage, object: nil)
            
        case .Like:
            settingsScreenPresentationDelegate?.likeApplication()
            
        case .Share:
            settingsScreenPresentationDelegate?.shareApplication()
            
        case .Review:
            // probably'll be deleted
            break
            
        case .Credits:
            settingsScreenPresentationDelegate?.showCredits()
            
        case .ContantInfo:
            settingsScreenPresentationDelegate?.showContactInfo()
            
        case .RestorePurchases:
            settingsScreenPresentationDelegate?.restorePurchases()
            
        case .RemoveAdds:
            settingsScreenPresentationDelegate?.removeAds()
            
        case .UIhand:
            let isLeftHandedUI = Settings.shared.isLeftHandedUI
            Settings.shared.isLeftHandedUI = !isLeftHandedUI
            Settings.shared.save()
            updateCellButtonImage()
            NotificationCenter.default.post(name: .changeTopButton, object: nil)            
        }
        
    }
    
}
