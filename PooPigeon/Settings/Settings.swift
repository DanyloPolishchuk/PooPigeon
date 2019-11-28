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
    
    private var language: Language
    var isLeftHandedUI: Bool
    var isSoundEffectsEnabled: Bool
    var isMusicEnabled: Bool
    
    var isApplicationLiked: Bool
    var isApplicaitonShared: Bool
    var isApplicationReviewed: Bool
    
    //TODO: add new progress variables ( best, total, e.t.c. )
    var bestScore: UInt
    var totalScore: UInt
    var amountOfLoses: UInt
    //TODO: add time counting timers to AppDelegate ?
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
            self.language = settings.language
            
            self.isLeftHandedUI = settings.isLeftHandedUI
            self.isSoundEffectsEnabled = settings.isSoundEffectsEnabled
            self.isMusicEnabled = settings.isMusicEnabled
            
            self.isApplicationLiked = settings.isApplicationLiked
            self.isApplicaitonShared = settings.isApplicaitonShared
            self.isApplicationReviewed = settings.isApplicationReviewed
            
            self.bestScore = settings.bestScore
            self.totalScore = settings.totalScore
            self.timeInSecsSpentInGame = settings.timeInSecsSpentInGame
            self.timesGameWasLaunched = settings.timesGameWasLaunched
            self.amountOfDaysGameWasLaunched = settings.amountOfDaysGameWasLaunched
            self.amountOfLoses = settings.amountOfLoses
            
        }else{
            
            print("\n\nSettings instance initialization from code\n\n")
            
            levels = [
                Level(levelNumber: 1, levelSceneFileName: "GameScene", birds:
                    [
                        Bird(birdNumber: 1, birdLevelNumber: 1, birdName: "Pigeon", birdIsUnlocked: true, birdSceneFileName: "bird", birdChallengeType: .None, birdChallengeScoreType: .None, neededChallengeNumberValue: nil, neededChallengeBoolValue: nil, neededChallengeDateValue: nil),
                        Bird(birdNumber: 2, birdLevelNumber: 1, birdName: "Test Bird #2", birdIsUnlocked: false, birdSceneFileName: "testBird#2", birdChallengeType: .TotalScore, birdChallengeScoreType: .NumberValue, neededChallengeNumberValue: 100, neededChallengeBoolValue: nil, neededChallengeDateValue: nil)
                    ]
                )
            ]
            
            currentLevel = levels[0]
            currentBird = levels[0].birds[0]
            
            language = Language.English
            
            isLeftHandedUI = false
            isSoundEffectsEnabled = true
            isMusicEnabled = true
            
            isApplicationLiked = false
            isApplicaitonShared = false
            isApplicationReviewed = false
            
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
    
    //MARK: - level & bird methods
    //
    func getNext(forLevelAtIndex levelIndex: Int?, forBirdAtIndex birdIndex: Int?) -> IndexPath? {
        
        var nextLevelIndex: Int?
        var nextBirdIndex: Int?
        
        var currentLevelIndex: Int
        var currentBirdIndex: Int
        
        if let levelIndex = levelIndex, let birdIndex = birdIndex {
            // check for currently presented in scene bird and level
            currentLevelIndex = levelIndex
            currentBirdIndex = birdIndex
        }else{
            // check for current from settings
            currentLevelIndex = currentLevel.levelNumber - 1
            currentBirdIndex = currentBird.birdNumber - 1
        }
        
        let currentLevelBirdsCount = getLevelAtIndex(index: currentLevelIndex)?.birds.count
        
        if let currentLevelBirdsCount = currentLevelBirdsCount, currentBirdIndex < currentLevelBirdsCount - 1 {
            nextBirdIndex = currentBirdIndex + 1
            nextLevelIndex = currentLevelIndex
            if let nextLevelIndex = nextLevelIndex, let nextBirdIndex = nextBirdIndex {
                return IndexPath(row: nextLevelIndex, section: nextBirdIndex)
            }
        }else{
            if currentLevelIndex < levels.count - 1 {
                nextLevelIndex = currentLevelIndex + 1
                nextBirdIndex = 0
                if let nextLevelIndex = nextLevelIndex, let nextBirdIndex = nextBirdIndex {
                    return IndexPath(row: nextLevelIndex, section: nextBirdIndex)
                }
            }else{
                return nil
            }
        }
        
    }
    
    func getPrevious(forLevelAtIndex levelIndex: Int?, forBirdAtIndex birdIndex: Int?) -> IndexPath? {
        
        var previousLevelIndex: Int?
        var previousBirdIndex: Int?
        
        var currentLevelIndex: Int
        var currentBirdIndex: Int
        
        if let levelIndex = levelIndex, let birdIndex = birdIndex {
            // check for currently presented in scene bird and level
            currentLevelIndex = levelIndex
            currentBirdIndex = birdIndex
        }else{
            // check for current from settings
            currentLevelIndex = currentLevel.levelNumber - 1
            currentBirdIndex = currentBird.birdNumber - 1
        }
        
        if currentBirdIndex > 0 {
            previousBirdIndex = currentBirdIndex - 1
            previousLevelIndex = currentLevelIndex
            if let nextLevelIndex = previousLevelIndex, let nextBirdIndex = previousBirdIndex {
                return IndexPath(row: nextLevelIndex, section: nextBirdIndex)
            }
        }else{
            if currentLevelIndex > 0 {
                previousLevelIndex = currentLevelIndex - 1
                previousBirdIndex = levels[previousLevelIndex!].birds.count - 1
                if let nextLevelIndex = previousLevelIndex, let nextBirdIndex = previousBirdIndex {
                    return IndexPath(row: nextLevelIndex, section: nextBirdIndex)
                }
            }else{
                return nil
            }
        }
        
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
