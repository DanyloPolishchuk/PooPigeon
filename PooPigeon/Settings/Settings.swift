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
    
    var currentLevel: Level
    var currentBird: Bird
    
    private var levels: [Level]
    private var birds: [Bird]
    
    private var language: Language
    
    var isLeftHandedUI: Bool
    var isSoundEffectsEnabled: Bool
    var isMusicEnabled: Bool
    var isApplicationLiked: Bool
    var isApplicaitonShared: Bool
    var isApplicationReviewed: Bool
    var isAddsRemovalPurchased: Bool
    
    //TODO: add new progress variables ( best, total, e.t.c. )
    var bestScore: UInt
    var totalScore: UInt
    var amountOfLoses: UInt

    var timeInSecsSpentInGame: UInt
    var timesGameWasLaunched: UInt
    var amountOfDaysGameWasLaunched: UInt
    
    //TODO: add restore purchase variables
    
    private init(){
        
        //TODO: delete print log once clear that settings singleton works as supposed to
        
        print("\n\nSettings singleton init\n\n")
        
        if let data = UserDefaults.standard.value(forKey: "settingsUDKey") as? Data, let settings = try? PropertyListDecoder().decode(Settings.self, from: data) {
            
            print("\n\nSettings instance initialization from UD\n\n")
            
            self.currentLevel = settings.currentLevel
            self.currentBird = settings.currentBird
            
            self.levels = settings.levels
            self.birds = settings.birds
            self.language = settings.language
            
            self.isLeftHandedUI = settings.isLeftHandedUI
            self.isSoundEffectsEnabled = settings.isSoundEffectsEnabled
            self.isMusicEnabled = settings.isMusicEnabled
            
            self.isApplicationLiked = settings.isApplicationLiked
            self.isApplicaitonShared = settings.isApplicaitonShared
            self.isApplicationReviewed = settings.isApplicationReviewed
            self.isAddsRemovalPurchased = settings.isAddsRemovalPurchased
            
            self.bestScore = settings.bestScore
            self.totalScore = settings.totalScore
            self.timeInSecsSpentInGame = settings.timeInSecsSpentInGame
            self.timesGameWasLaunched = settings.timesGameWasLaunched
            self.amountOfDaysGameWasLaunched = settings.amountOfDaysGameWasLaunched
            self.amountOfLoses = settings.amountOfLoses
            
        }else{
            
            print("\n\nSettings instance initialization from code\n\n")
            
            //TODO: replace default level & bird values to separate .swift file / JSON
            levels = [
                
                Level(levelNumber: 1,
                      levelSceneFileName: "GameScene",
                      // REPLACE_WITH_ACTUAL_SOUND_FILE
                      levelMusicSoundFileName: "signalRocketSound",
                      enemies: [
                        Enemy(texture: "level1ManWalkingFrame1",
                              physicsBodyTexture: "level1ManWalkingBodyTexture",
                              animationTextureNames: [
                                "level1ManWalkingFrame1",
                                "level1ManWalkingFrame2",
                                "level1ManWalkingFrame3"
                            ])
                    ],
                      levelIsUnlocked: true,
                      levelChallengeType: .None,
                      levelChallengeScoreType: .None,
                      currentChallengeNumberValueProgress: nil,
                      currentChallengeBoolValueProgress: nil,
                      currentChallengeDateValueProgress: nil,
                      neededChallengeNumberValue: nil,
                      neededChallengeBoolValue: nil,
                      neededChallengeDateValue: nil
                )
            ]
            
            birds = [
                Bird(birdNumber: 1,
                     birdName: "Pigeon",
                     birdSpawnPosition: CGPoint(x: 0, y: 680),
                     birdTexture: "pigeonDefault",
                     birdAnimationTextureNames: [
                        "pigeonDefault",
                        "pigeonDefaultFrame2"
                    ],
                     birdShootTextureName: "pigeonDefaultShootFrame",
                     // REPLACE_WITH_ACTUAL_SOUND_FILE
                     birdSoundFileName: "signalRocketSound",
                     birdIsUnlocked: true,
                     birdChallengeType: .None,
                     birdChallengeScoreType: .None,
                     currentChallengeNumberValueProgress: nil,
                     currentChallengeBoolValueProgress: nil,
                     currentChallengeDateValueProgress: nil,
                     neededChallengeNumberValue: nil,
                     neededChallengeBoolValue: nil,
                     neededChallengeDateValue: nil)
            ]
            
            currentLevel = levels[0]
            currentBird = birds[0]
            
            language = Language.English
            
            isLeftHandedUI = false
            isSoundEffectsEnabled = true
            isMusicEnabled = true
            
            isApplicationLiked = false
            isApplicaitonShared = false
            isApplicationReviewed = false
            isAddsRemovalPurchased = false
            
            bestScore = 0
            totalScore = 0
            timeInSecsSpentInGame = 0
            timesGameWasLaunched = 0
            amountOfDaysGameWasLaunched = 0
            amountOfLoses = 0
            
            save()
        }
        
    }
    
    func save(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self), forKey: "settingsUDKey")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - Get & Set methods
    //
    func getTemporarySettings() -> [Bool] {
        return [
            isApplicationLiked,
            isApplicaitonShared,
            isApplicationReviewed,
            isAddsRemovalPurchased
        ]
    }
    
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
    
//    func getBirdsCountOfLevelAtIndex(_ index: Int) -> Int{
//        return self.levels[index].birds.count
//    }
//    func getBirdFromLevelAtIndex(_ levelIndex: Int, withBirdIndex birdIndex: Int) -> Bird {
//        return levels[levelIndex].birds[birdIndex]
//    }

    
    //MARK: - bird methods
    //
//    func getBirdsCound() -> Int{
//        return self.birds.count
//    }
    
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
