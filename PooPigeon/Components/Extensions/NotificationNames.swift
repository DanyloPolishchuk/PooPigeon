//
//  NotificationNames.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/30/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // NotificationKey
    
    static let setupScoreKey = Notification.Name(rawValue: "setupScoreNotificationKey")
    static let showGameOverKey = Notification.Name(rawValue: "showGameOverNotificationKey")
    
    static let turnSFXOn = Notification.Name("turnSFXOnNotificationKey")
    static let turnSFXOff = Notification.Name("turnSFXOffNotificationKey")
    static let turnMusicOn = Notification.Name("turnMusicOnNotificationKey")
    static let turnMusicOff = Notification.Name("turnMusicOffNotificationKey")
    
    static let buttonPressed = Notification.Name("buttonPressedNotificationKey")
    static let sfxSoundPlay = Notification.Name("sfxSoundPlayNotificationKey")
    
    static let changeTopButton = Notification.Name("changeTopButtonNotificationKey")
    static let updateLanguage = Notification.Name("updateLanguageNotificationKey")
    
    static let setupCurrentLevelAndBird = Notification.Name("setupCurrentLevelAndBirdNotificationKey")
    static let setupLevelAndBird = Notification.Name("setupLevelAndBirdNotificationKey")
    static let setupCurrentBird = Notification.Name("setupCurrentBirdNotificationKey")
    static let setupBird = Notification.Name("setupBirdNotificationKey")
    
    static let pauseOnResignActive = Notification.Name("pauseOnResignActiveNotificationKey")

}
