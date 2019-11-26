//
//  Settings.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit

class Settings: Codable {
    
    static let shared: Settings = {
        return Settings()
    }()
    
    //MARK: - Properties
    //
    
    //TODO: separate important properties that must be encrypted from usual ones (like music, sound effects, leftHandUI ... ) for keychainUsage     OR
    //TODO: rewrite using SecureDefaults https://github.com/vpeschenkov/SecureDefaults
    
    // - sensitive
    // - insensitive
    
    private var levels: [Level]
    private var birds: [Bird]
    private var language: Language
    var isLeftHandedUI: Bool
    var isSoundEffectsEnabled: Bool
    var isMusicEnabled: Bool
    var isApplicationLiked: Bool
    private var isApplicaitonShared: Bool
    //TODO: add restore purchase variables
    //TODO: add progress variables ( best, total, e.t.c. )
    
    private init(){
        
        //TODO: delete print log once clear that settings singleton works as supposed to
        
        print("\n\nSettings singleton init\n\n")
        
        if let data = UserDefaults.standard.value(forKey: "settingsUDKey") as? Data, let settings = try? PropertyListDecoder().decode(Settings.self, from: data) {
            
            print("\n\nSettings instance initialization from UD\n\n")
            
            self.levels = settings.levels
            self.birds = settings.birds
            self.language = settings.language
            
            self.isLeftHandedUI = settings.isLeftHandedUI
            self.isSoundEffectsEnabled = settings.isSoundEffectsEnabled
            self.isMusicEnabled = settings.isMusicEnabled
            self.isApplicationLiked = settings.isApplicationLiked
            self.isApplicaitonShared = settings.isApplicaitonShared
            
        }else{
            
            print("\n\nSettings instance initialization from code\n\n")
            
            levels = [
                Level(levelNumber: 1, levelSceneFileName: "GameScene")
            ]
            birds = [
                Bird(birdNumber: 1,
                     birdLevelNumber: 1,
                     birdName: "Pigeon",
                     birdIsOpened: true,
                     birdSceneFileName: "Pigeon",
                     birdChallengType: .None,
                     birdChallengeScoreType: .None)
            ]
            
            language = Language.English
            
            isLeftHandedUI = false
            isSoundEffectsEnabled = true
            isMusicEnabled = true
            isApplicationLiked = false
            isApplicaitonShared = false
            
            save()
        }
        
    }
    
    func save(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: "settingsUDKey")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - level methods
    //
    func getLevelsCount() -> Int{
        return self.levels.count
    }
    
    func getLevelAtIndex(index: Int) -> Level? {
        if index < levels.count {
            return levels[index]
        }else{
            return nil
        }
    }

    
    //MARK: - bird methods
    //
    func getBirdsCound() -> Int{
        return self.birds.count
    }
    
    //MARK: - language methods
    //
    func getLanguage() -> Language{
        return self.language
    }
    func changeLanguageTo(language: Language){
        if self.language != language{
            self.language = language
            self.save()
        }
    }
    
    
    //TODO: change this method for birds arr
//    func updateLevelAt(index: Int, level: Level){
//        if index < levels.count {
//            levels[index].levelState = level.levelState
//            levels[index].mainHeroCurrentPosition = level.mainHeroCurrentPosition
//            levels[index].mainHeroInventory = level.mainHeroInventory
//            self.save()
//        }
//    }
    
}
