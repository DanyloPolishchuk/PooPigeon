//
//  ProgressTableViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/8/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    
    var challengeType: ChallengeType?
    
    @IBOutlet weak var progressTypeNameLabel: UILabel!
    @IBOutlet weak var progressValueLabel: UILabel!
    
    func displayContent(challengeType: ChallengeType){
        self.challengeType = challengeType
        
        progressTypeNameLabel.text = LocalizationHelper.defaultLocalizer.stringForKey(key: challengeType.rawValue)
        switch challengeType {
        case .BestScore:
            progressValueLabel.text = String(Settings.shared.bestScore)
        case.TotalScore:
            progressValueLabel.text = String(Settings.shared.totalScore)
        case .TotalLoseTimes:
            progressValueLabel.text = String(Settings.shared.amountOfLoses)
        case .TotalTimeSpentInGame:
            progressValueLabel.text = UInt.secondsToString(seconds: Settings.shared.timeInSecsSpentInGame)
        case .TotalTimesGameWasLaunched:
            progressValueLabel.text = String(Settings.shared.timesGameWasLaunched)
        case .TotalDaysGameWasLaunched:
            progressValueLabel.text = String(Settings.shared.amountOfDaysGameWasLaunched)
        @unknown default:
            progressValueLabel.text = ""
            break
        }
    }
    
}
