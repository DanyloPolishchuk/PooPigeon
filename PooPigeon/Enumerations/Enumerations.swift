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
    case None           = 0
    case Edge           = 1     //0b1
    case Human          = 2     //0b10
    case Egg            = 4     //0b100
    case Field          = 8     //0b1000
    case Bonus          = 16    //0b10000
    case Poo            = 32    //0b100000
}

enum Language: String, Codable {
    case English = "en"
    case Ukrainian = "uk"
    case Russian = "ru"
}

enum ChallengeType: String, Codable {
    case None = "Default" // "No Challenge"
    case BestScore = "Best Score" // int
    case TotalScore = "Total Score"// int
    case TotalTimeSpentInGame = "Time Spent In Game" // int
    case TotalTimesGameWasLaunched = "Launch Game"// int
    case TotalDaysGameWasLaunched = "Launch Days" // int
    case UniqueLaunchDay = "Launch At Day" // Date
    case TotalLoseTimes = "Lose Score"// int
    case LikeUs = "Like Us"// (App Store) // bool
    case ShareUs = "Share Us" // bool
    case ReviewUs = "Review Us"// (App Store) // bool
    // maybe add more like advanced collision checks AKA headshots, bodyshots...
}

enum ChallengeScoreType: String, Codable {
    case None
    case NumberValue
    // may be replace Date scoreType with ususal bool ( it is whether user started on certain date or not like date has some progress / countdown to it.
    case DateValue
    case BoolValue
}

enum SettingButtonType {
    case Sound
    case Music
    case Language
    case Like
    case Share
    case Review
    case Credits
    case ContantInfo
    case RestorePurchases
    case RemoveAdds
    case UIhand
}

enum ShopButtonType {
    case UnlockAllBirds
    case UnlockAllLevels
}
