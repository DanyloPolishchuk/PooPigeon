//
//  Settings.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

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
    var currentHero: Hero
    
    private var levels: [Level]
    private var heroes: [Hero]
    private var wallpapers: [Wallpaper]
    
    private var language: Language
    
    var isFirstLaunch: Bool
    
    var isLeftHandedUI: Bool
    var isSoundEffectsEnabled: Bool
    var isMusicEnabled: Bool
    
    var isApplicationLiked: Bool
    var isApplicaitonShared: Bool
    var isApplicationReviewed: Bool
    
    var isAddsRemovalPurchased: Bool
    var isUnlockAllPurchased: Bool
    var isUnlockAllHeroesPurchased: Bool
    var isUnlockAllLevelsPurchased: Bool

    var bestScore: UInt
    var totalScore: UInt
    var amountOfLoses: UInt

    var timeInSecsSpentInGame: UInt
    var timesGameWasLaunched: UInt
    
    var lastLaunchTimeDate: Date
    var amountOfDaysGameWasLaunched: UInt
    
    //MARK: - Computed properties
    //
    var isEveryHeroUnlocked: Bool {
        get{
            return self.heroes.allSatisfy({ $0.isUnlocked })
        }
    }
    
    var isEveryLevelUnlocked: Bool {
        get{
            return self.levels.allSatisfy({ $0.levelIsUnlocked })
        }
    }
    
    private init(){
        
        print("\n\nSettings singleton init\n\n")
        
        if let data = UserDefaults.standard.value(forKey: "settingsUDKey") as? Data, let settings = try? PropertyListDecoder().decode(Settings.self, from: data) {
            
            print("\n\nSettings instance initialization from UD\n\n")
            
            self.currentLevel = settings.currentLevel
            self.currentHero = settings.currentHero
            
            self.levels = settings.levels
            self.heroes = settings.heroes
            self.wallpapers = settings.wallpapers
            
            self.language = settings.language
            
            self.isFirstLaunch = settings.isFirstLaunch
            
            self.isLeftHandedUI = settings.isLeftHandedUI
            self.isSoundEffectsEnabled = settings.isSoundEffectsEnabled
            self.isMusicEnabled = settings.isMusicEnabled
            
            self.isApplicationLiked = settings.isApplicationLiked
            self.isApplicaitonShared = settings.isApplicaitonShared
            self.isApplicationReviewed = settings.isApplicationReviewed
            
            self.isAddsRemovalPurchased = settings.isAddsRemovalPurchased
            self.isUnlockAllPurchased = settings.isUnlockAllPurchased
            self.isUnlockAllHeroesPurchased = settings.isUnlockAllHeroesPurchased
            self.isUnlockAllLevelsPurchased = settings.isUnlockAllLevelsPurchased
            
            self.bestScore = settings.bestScore
            self.totalScore = settings.totalScore
            self.lastLaunchTimeDate = settings.lastLaunchTimeDate
            self.timeInSecsSpentInGame = settings.timeInSecsSpentInGame
            self.timesGameWasLaunched = settings.timesGameWasLaunched
            self.amountOfDaysGameWasLaunched = settings.amountOfDaysGameWasLaunched
            self.amountOfLoses = settings.amountOfLoses
            
        }else{
            
            print("\n\nSettings instance initialization from code\n\n")
            
            //TODO: replace default level & bird values to separate .swift file / JSON
            levels = [
                
                Level(levelName: "City",
                      levelNumber: 1,
                      levelSceneFileName: "Level1Scene",
                      // REPLACE_WITH_ACTUAL_SOUND_FILE
                    levelMusicSoundFileName: "signalRocketSound",
                    levelPreviewImageName: "level1NewYorkBackground" ,
                    bird: Bird(birdNumber: 1,
                               birdName: "Pigeon",
                               birdSpawnPosition: CGPoint(x: 0, y: 680),
                               birdTexture: "pigeonDefault",
                               birdAnimationTextureNames: [
                                "pigeonDefault",
                                "pigeonDefaultFrame2"],
                               birdShootTextureName: "pigeonDefaultShootFrame",
                               birdSoundFileName: "signalRocketSound"),
                    levelIsUnlocked: true,
                    levelChallengeType: .None,
                    levelChallengeScoreType: .None,
                    currentChallengeNumberValueProgress: nil,
                    currentChallengeBoolValueProgress: nil,
                    currentChallengeDateValueProgress: nil,
                    neededChallengeNumberValue: nil,
                    neededChallengeBoolValue: nil,
                    neededChallengeDateValue: nil
                ),
                Level(levelName: "Cave",
                      levelNumber: 2,
                      levelSceneFileName: "Level2Scene",
                      // REPLACE_WITH_ACTUAL_SOUND_FILE
                    levelMusicSoundFileName: "signalRocketSound",
                    levelPreviewImageName: "level2BGWallpaper" ,
                    bird: Bird(birdNumber: 2,
                               birdName: "Bat",
                               birdSpawnPosition: CGPoint(x: 0, y: 744),
                               birdTexture: "batFrame1",
                               birdAnimationTextureNames: [
                                "batFrame1",
                                "batFrame2"],
                               birdShootTextureName: "batShootFrame",
                               birdSoundFileName: "signalRocketSound"),
                    levelIsUnlocked: false,
                    levelChallengeType: .BestScore,
                    levelChallengeScoreType: .NumberValue,
                    currentChallengeNumberValueProgress: 0,
                    currentChallengeBoolValueProgress: nil,
                    currentChallengeDateValueProgress: nil,
                    neededChallengeNumberValue: 100,
                    neededChallengeBoolValue: nil,
                    neededChallengeDateValue: nil
                )
            ]
            
            heroes = [
                Hero(number: 1,
                     name: "Casey",
                     texture: "hero1IdleFrame1",
                     physicsBodyTexture: "hero1PhysicsBodyTexture",
                     idleTextureNames: [
                        "hero1IdleFrame1",
                        "hero1IdleFrame2"
                    ],
                     hitTextureNames: [
                        "hero1HitFrame1",
                        "hero1HitFrame2"
                    ],
                     loseTextureNames: [
                        "hero1LoseFrame1",
                        "hero1LoseFrame2"
                    ],
                     isUnlocked: true,
                     challengeType: .None,
                     challengeScoreType: .None,
                     currentChallengeNumberValueProgress: nil,
                     currentChallengeBoolValueProgress: nil,
                     currentChallengeDateValueProgress: nil,
                     neededChallengeNumberValue: nil,
                     neededChallengeBoolValue: nil,
                     neededChallengeDateValue: nil),
                Hero(number: 2,
                     name: "Steve",
                     texture: "hero2IdleFrame1",
                     physicsBodyTexture: "hero2PhysicsBodyTexture",
                     idleTextureNames: [
                        "hero2IdleFrame1",
                        "hero2IdleFrame2"
                    ],
                     hitTextureNames: [
                        "hero2HitFrame1",
                        "hero2HitFrame2"
                    ],
                     loseTextureNames: [
                        "hero2LoseFrame1",
                        "hero2LoseFrame2"
                    ],
                     isUnlocked: false,
                     challengeType: .TotalScore,
                     challengeScoreType: .NumberValue,
                     currentChallengeNumberValueProgress: 0,
                     currentChallengeBoolValueProgress: nil,
                     currentChallengeDateValueProgress: nil,
                     neededChallengeNumberValue: 100,
                     neededChallengeBoolValue: nil,
                     neededChallengeDateValue: nil)
            ]
            
            wallpapers = [
                Wallpaper(wallpaperNumber: 1,
                          wallpaperImageName: "level1NewYorkBackground",
                          isWallpaperUnlocked: false),
                Wallpaper(wallpaperNumber: 2,
                          wallpaperImageName: "level2BGWallpaper",
                          isWallpaperUnlocked: false)
            ]
            
            currentLevel = levels[0]
            currentHero = heroes[0]
            
            language = Language.English
            
            isFirstLaunch = true
            
            isLeftHandedUI = false
            isSoundEffectsEnabled = true
            isMusicEnabled = true
            
            isApplicationLiked = false
            isApplicaitonShared = false
            isApplicationReviewed = false
            
            isAddsRemovalPurchased = false
            isUnlockAllPurchased = false
            isUnlockAllHeroesPurchased = false
            isUnlockAllLevelsPurchased = false
            
            bestScore = 0
            totalScore = 0
            lastLaunchTimeDate = Date()
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
    
    //MARK: - Progressable properties update methods
    //
    func updateCurrentProgressProperties(){
        self.heroes = self.heroes.map({ (hero: Hero) -> Hero in
            var newHero = hero
            if !newHero.isUnlocked {
                switch newHero.challengeType{
                case .BestScore:
                    newHero.currentChallengeNumberValueProgress = self.bestScore
                case .TotalScore:
                    newHero.currentChallengeNumberValueProgress = self.totalScore
                case .TotalLoseTimes:
                    newHero.currentChallengeNumberValueProgress = self.amountOfLoses
                case .TotalTimeSpentInGame:
                    newHero.currentChallengeNumberValueProgress = self.timeInSecsSpentInGame
                case .TotalTimesGameWasLaunched:
                    newHero.currentChallengeNumberValueProgress = self.timesGameWasLaunched
                case .TotalDaysGameWasLaunched:
                    newHero.currentChallengeNumberValueProgress = self.amountOfDaysGameWasLaunched
                default:
                    break
                }
            }
            return newHero
        })
        self.levels = self.levels.map({ (level: Level) -> Level in
            var newLevel = level
            if !newLevel.levelIsUnlocked {
                switch newLevel.levelChallengeType{
                case .BestScore:
                    newLevel.currentChallengeNumberValueProgress = self.bestScore
                case .TotalScore:
                    newLevel.currentChallengeNumberValueProgress = self.totalScore
                case .TotalLoseTimes:
                    newLevel.currentChallengeNumberValueProgress = self.amountOfLoses
                case .TotalTimeSpentInGame:
                    newLevel.currentChallengeNumberValueProgress = self.timeInSecsSpentInGame
                case .TotalTimesGameWasLaunched:
                    newLevel.currentChallengeNumberValueProgress = self.timesGameWasLaunched
                case .TotalDaysGameWasLaunched:
                    newLevel.currentChallengeNumberValueProgress = self.amountOfDaysGameWasLaunched
                default:
                    break
                }
            }
            return newLevel
        })
        save()
    }
    
    //MARK: - Temporary Settings
    func getTemporarySettings() -> [Bool] {
        return [
            isApplicationLiked,
            isApplicaitonShared,
            isApplicationReviewed,
            isAddsRemovalPurchased
        ]
    }
    //MARK: - Level & Hero methods
    //
    func getHeroes() -> [Hero] {
        return self.heroes
    }
    func getLevels() -> [Level] {
        return self.levels
    }
    func unlockAll(){
        for index in 0..<heroes.count {
            heroes[index].isUnlocked = true
        }
        for index in 0..<levels.count {
            levels[index].levelIsUnlocked = true
        }
        save()
    }
    func unlockAllHeroes(){
        for index in 0..<heroes.count {
            heroes[index].isUnlocked = true
        }
        save()
    }
    func unlockAllLevels(){
        for index in 0..<levels.count {
            levels[index].levelIsUnlocked = true
        }
        save()
    }
    
    //MARK: - Wallpapers methods
    //
    func getWallpapers() -> [Wallpaper] {
        return self.wallpapers
    }
    func unlockWallpaperAtIndex(_ index: Int){
        if index < self.wallpapers.count {
            wallpapers[index].isWallpaperUnlocked = true
            save()
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
    
    //MARK: - Language methods
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
    
}
