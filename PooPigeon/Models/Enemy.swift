//
//  Hero.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

struct Hero: Codable {
    
    let number: Int
    let name: String
    
    let texture: String
    let physicsBodyTexture: String
    let animationTextureNames: [String]
    // let animationCatchTextureNames: [String]
    
    var isUnlocked: Bool
    let challengeType: ChallengeType
    let challengeScoreType: ChallengeScoreType
    var currentChallengeNumberValueProgress: UInt? {
        didSet{
            if self.currentChallengeNumberValueProgress != nil,
                self.neededChallengeNumberValue != nil,
                self.currentChallengeNumberValueProgress! >= self.neededChallengeNumberValue! {
                isUnlocked = true
            }
        }
    }
    var currentChallengeBoolValueProgress: Bool?
    var currentChallengeDateValueProgress: String?
    let neededChallengeNumberValue: UInt?
    let neededChallengeBoolValue: Bool?
    let neededChallengeDateValue: String?
    
}
