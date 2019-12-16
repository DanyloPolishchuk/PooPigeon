//
//  Bird.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

struct Bird: Codable {
    
    let birdNumber: Int
//    let birdLevelNumber: Int
    let birdName: String
//    let birdSceneFileName: String
    
    let birdSpawnPosition: CGPoint
    let birdTexture: String
    let birdAnimationTextureNames: [String]
    let birdShootTextureName: String
    let birdSoundFileName: String
    
    var birdIsUnlocked: Bool
    let birdChallengeType: ChallengeType
    let birdChallengeScoreType: ChallengeScoreType
    var currentChallengeNumberValueProgress: UInt?
    var currentChallengeBoolValueProgress: Bool?
    var currentChallengeDateValueProgress: String?
    let neededChallengeNumberValue: UInt?
    let neededChallengeBoolValue: Bool?
    let neededChallengeDateValue: String?
    //TODO: find out an implementation way to track current challenge progress of each bird & unlock bird once challenge passed, & set isNewUnlockedBird/Level flag to true
    //TODO: add reference scene file name property & spawn position ?
    //TODO: add current Progress string computed property / func with all date & number formatting and etc.
    
}
