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
    let birdLevelNumber: Int
    let birdName: String
    var birdIsUnlocked: Bool
    let birdSceneFileName: String
    let birdChallengeType: ChallengeType
    let birdChallengeScoreType: ChallengeScoreType
    let neededChallengeNumberValue: UInt?
    let neededChallengeBoolValue: Bool?
    let neededChallengeDateValue: String?
    //TODO: find out an implementation way to track current challenge progress of each bird & unlock bird once challenge passed, & set isNewUnlockedBird/Level flag to true
    
}
