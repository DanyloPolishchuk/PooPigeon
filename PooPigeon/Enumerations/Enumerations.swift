//
//  Enumerations.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/12/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

enum PhysicsCategory: UInt32 {
    case None   = 0
    case Edge   = 1     //0b1
    case Human  = 2     //0b10
    case Bullet = 4     //0b100
    case Field  = 8     //0b1000
}

enum Language: String, Codable {
    case English
    case Ukrainian
    case Russian
}

enum ChallengeType: String, Codable {
    case None
    case BestScore // int 
    case TotalScore // int
    case TotalTimeSpentInGame // int
    case TotalTimesGameWasLaunched // int
    case TotalDaysGameWasLaunched // int
    case UniqueLaunchDay // Date
    case TotalLoseTimes // int
    case LikeUs // (App Store) // bool
    case ShareUs // bool
    case ReviewUs // (App Store) // bool
    // maybe add more like advanced collision checks AKA headshots, bodyshots...
}

enum ChallengeScoreType: String, Codable {
    case None
    case NumberValue
    case DateValue
    case BoolValue
}

