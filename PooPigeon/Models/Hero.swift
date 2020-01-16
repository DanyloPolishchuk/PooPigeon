//
//  Bird.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

struct Hero: Codable {
    
    let number: Int
//    let birdLevelNumber: Int
    let name: String
//    let birdSceneFileName: String
    
    let birdSpawnPosition: CGPoint
    let textureName: String
    let animationTextureNames: [String]
    let birdShootTextureName: String
    let birdSoundFileName: String
    
    var birdIsUnlocked: Bool
    let birdChallengeType: ChallengeType
    let birdChallengeScoreType: ChallengeScoreType
    var currentChallengeNumberValueProgress: UInt? {
        didSet{
            if self.currentChallengeNumberValueProgress != nil,
                self.neededChallengeNumberValue != nil,
                self.currentChallengeNumberValueProgress! >= self.neededChallengeNumberValue! {
                birdIsUnlocked = true
            }
        }
    }
    var currentChallengeBoolValueProgress: Bool?
    var currentChallengeDateValueProgress: String?
    let neededChallengeNumberValue: UInt?
    let neededChallengeBoolValue: Bool?
    let neededChallengeDateValue: String?
    //TODO: find out an implementation way to track current challenge progress of each bird & unlock bird once challenge passed, & set isNewUnlockedBird/Level flag to true. 
}
