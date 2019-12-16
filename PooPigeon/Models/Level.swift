//
//  Level.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

struct Level: Codable {
    
    let levelName: String
    let levelNumber: Int
    let levelSceneFileName: String
    let levelMusicSoundFileName: String
    let levelPreviewImageName: String
    let enemies: [Enemy]
    
    var levelIsUnlocked: Bool
    let levelChallengeType: ChallengeType
    let levelChallengeScoreType: ChallengeScoreType
    var currentChallengeNumberValueProgress: UInt?
    var currentChallengeBoolValueProgress: Bool?
    var currentChallengeDateValueProgress: String?
    let neededChallengeNumberValue: UInt?
    let neededChallengeBoolValue: Bool?
    let neededChallengeDateValue: String?
}
