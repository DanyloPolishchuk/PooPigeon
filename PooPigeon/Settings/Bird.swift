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
    var birdIsOpened: Bool
    let birdSceneFileName: String
    let birdChallengType: ChallengeType
    let birdChallengeScoreType: ChallengeScoreType
    
    //TODO: manage "Any" type saving in UD or replace "birdChallengeNeedeScore" with "ChallengeScoreType".count amount of properties each unique type
    
//    let birdChallengeNeedeScore: Any
}
