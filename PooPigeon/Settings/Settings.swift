//
//  Settings.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit
import SecureDefaults

class Settings: Codable {
    
    static let shared: Settings = {
        return Settings()
    }()
    
    //MARK: - Properties
    //
    
    var currentLevel: Level
    var currentHero: Hero
    
    private var levels: [Level]
    private var heroes: [Hero]
    private var wallpapers: [Wallpaper]
    
    private var language: Language
    
    var isFirstLaunch: Bool
    
    var isTutorialSupposedToBeShown: Bool
    
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
        
        print("\nSettings singleton init\n")
        
        if let data = secureDefaultsShared.value(forKey: "settingsUDKey") as? Data, let settings = try? PropertyListDecoder().decode(Settings.self, from: data) {

            print("\nSettings instance initialization from UD\n")
            
            self.currentLevel = settings.currentLevel
            self.currentHero = settings.currentHero
            
            self.levels = settings.levels
            self.heroes = settings.heroes
            self.wallpapers = settings.wallpapers
            
            self.language = settings.language
            
            self.isFirstLaunch = settings.isFirstLaunch
            
            self.isTutorialSupposedToBeShown = settings.isTutorialSupposedToBeShown
            
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
            
            print("\nSettings instance initialization from \"SettingsDefault.json\" \n")
            
            let settingsDefaultJSONURL = Bundle.main.url(forResource: "SettingsDefault", withExtension: "json")!
            let data = try! Data(contentsOf: settingsDefaultJSONURL)
            let settings = try! JSONDecoder().decode(Settings.self, from: data)

            self.currentLevel = settings.currentLevel
            self.currentHero = settings.currentHero
            
            self.levels = settings.levels
            self.heroes = settings.heroes
            self.wallpapers = settings.wallpapers
            
            self.language = settings.language
            LocalizationHelper.defaultLocalizer.setSelectedLanguage(lang: language.rawValue)
            
            self.isFirstLaunch = settings.isFirstLaunch
            
            self.isTutorialSupposedToBeShown = settings.isTutorialSupposedToBeShown
            
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
            
            save()
        }
        
    }
    
    func save(){
        secureDefaultsShared.set(try? PropertyListEncoder().encode(self), forKey: "settingsUDKey")
        secureDefaultsShared.synchronize()
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
            LocalizationHelper.defaultLocalizer.setSelectedLanguage(lang: language.rawValue)
            self.save()
        }
    }
    
}
