//
//  ShopCollectionViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/13/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    var hero: Hero?
    var level: Level?
    
    @IBOutlet weak var birdOrLevelImageView: UIImageView!
    @IBOutlet weak var unlockedStatusImageView: UIImageView!
    @IBOutlet weak var selectedStatusImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var challengeTypeLabel: UILabel!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    
    
    //MARK: - Setup methods
    //
    func displayContent(hero: Hero){
        self.hero = hero
        
        birdOrLevelImageView.image = UIImage(named: hero.texture)
        unlockedStatusImageView.image = UIImage(named: hero.isUnlocked ? "unlockedIcon" : "lockedIcon")
        nameLabel.text = hero.name
        
        switch hero.challengeType {
        case .TotalTimeSpentInGame:
            // replace with localized one
            let localizedTimeInGameString = "Time in game"
            var neededTimeString = ""
            if let neededNumValue = hero.neededChallengeNumberValue{
                neededTimeString = UInt.secondsToString(seconds: neededNumValue)
            }
            challengeTypeLabel.text = "\(localizedTimeInGameString): \(neededTimeString)"
        default:
            challengeTypeLabel.text = hero.challengeType.rawValue
        }
        
        switch hero.challengeScoreType {
        case .NumberValue:
            if let current = hero.currentChallengeNumberValueProgress, let needed = hero.neededChallengeNumberValue{
                if hero.isUnlocked{
                    if hero.challengeType == .TotalTimeSpentInGame{
                        challengeProgressLabel.text = "Time left: 0m"
                    }else{
                        challengeProgressLabel.text = "\(needed) / \(needed)"
                    }
                }else{
                    if hero.challengeType == .TotalTimeSpentInGame {
                        let localizedTimeInGameString = "Time left"
                        let timeDifference = needed - current
                        let leftTimeString = UInt.secondsToString(seconds: timeDifference)
                        challengeProgressLabel.text = "\(localizedTimeInGameString): \(leftTimeString)"
                    }else{
                        challengeProgressLabel.text = "\(current) / \(needed)"

                    }
                }
            }
        case .BoolValue:
            if hero.neededChallengeBoolValue == hero.currentChallengeBoolValueProgress{
                challengeProgressLabel.text = "Completed"
            }else{
                challengeProgressLabel.text = "Not Completed"
            }
        case .DateValue:
            if let current = hero.currentChallengeDateValueProgress, let needed = hero.neededChallengeDateValue{
                challengeProgressLabel.text = "\(current) / \(needed)"
            }
        case .None:
            challengeProgressLabel.text = ""
            break
        }
        
    }
    
    func displayContent(level: Level){
        self.level = level
        
        birdOrLevelImageView.image = UIImage(named: level.levelPreviewImageName)
        unlockedStatusImageView.image = UIImage(named: level.levelIsUnlocked ? "unlockedIcon" : "lockedIcon")
        nameLabel.text = level.levelName
        
        switch level.levelChallengeType {
        case .None:
            challengeTypeLabel.text = level.levelChallengeType.rawValue
        case .TotalTimeSpentInGame:
            // replace with localized one
            let localizedTimeInGameString = "Time in game"
            var neededTimeString = ""
            if let neededNumValue = level.neededChallengeNumberValue{
                neededTimeString = UInt.secondsToString(seconds: neededNumValue)
            }
            challengeTypeLabel.text = "\(localizedTimeInGameString): \(neededTimeString)"
        default:
            challengeTypeLabel.text = level.levelChallengeType.rawValue
        }
        
        switch level.levelChallengeScoreType {
        case .NumberValue:
            if let current = level.currentChallengeNumberValueProgress, let needed = level.neededChallengeNumberValue{
                if level.levelIsUnlocked{
                    if level.levelChallengeType == .TotalTimeSpentInGame{
                        challengeProgressLabel.text = "Time left: 0m"
                    }else{
                        challengeProgressLabel.text = "\(needed) / \(needed)"
                    }
                }else{
                    if level.levelChallengeType == .TotalTimeSpentInGame {
                        let localizedTimeInGameString = "Time left"
                        let timeDifference = needed - current
                        let leftTimeString = UInt.secondsToString(seconds: timeDifference)
                        challengeProgressLabel.text = "\(localizedTimeInGameString): \(leftTimeString)"
                    }else{
                        challengeProgressLabel.text = "\(current) / \(needed)"
                        
                    }
                }
            }
        case .BoolValue:
            if level.neededChallengeBoolValue == level.currentChallengeBoolValueProgress{
                challengeProgressLabel.text = "Completed"
            }else{
                challengeProgressLabel.text = "Not Completed"
            }
        case .DateValue:
            if let current = level.currentChallengeDateValueProgress, let needed = level.neededChallengeDateValue{
                challengeProgressLabel.text = "\(current) / \(needed)"
            }
        case .None:
            challengeProgressLabel.text = ""
            break
        }
        
    }
    
    //MARK: - Selection methods
    //
    func selectCell(){
        self.selectedStatusImageView.isHidden = false
    }
    
    func deselectCell(){
        self.selectedStatusImageView.isHidden = true
    }
    
}
