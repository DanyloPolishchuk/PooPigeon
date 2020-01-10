//
//  ShopCollectionViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/13/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    var bird: Bird?
    var level: Level?
    
    @IBOutlet weak var birdOrLevelImageView: UIImageView!
    @IBOutlet weak var unlockedStatusImageView: UIImageView!
    @IBOutlet weak var selectedStatusImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var challengeTypeLabel: UILabel!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    
    
    //MARK: - Setup methods
    //
    override func awakeFromNib() {
        self.selectedStatusImageView.image = UIImage(named: "checkIcon")
        self.selectedStatusImageView.isHidden = true
    }
    
    func displayContent(bird: Bird){
        self.bird = bird
        
        birdOrLevelImageView.image = UIImage(named: bird.birdTexture)
        unlockedStatusImageView.image = UIImage(named: bird.birdIsUnlocked ? "unlockedIcon" : "lockedIcon")
        nameLabel.text = bird.birdName
        
        switch bird.birdChallengeType {
        case .TotalTimeSpentInGame:
            // replace with localized one
            let localizedTimeInGameString = "Time in game"
            var neededTimeString = ""
            if let neededNumValue = bird.neededChallengeNumberValue{
                neededTimeString = UInt.secondsToString(seconds: neededNumValue)
            }
            challengeTypeLabel.text = "\(localizedTimeInGameString): \(neededTimeString)"
        default:
            challengeTypeLabel.text = bird.birdChallengeType.rawValue
        }
        
        switch bird.birdChallengeScoreType {
        case .NumberValue:
            if let current = bird.currentChallengeNumberValueProgress, let needed = bird.neededChallengeNumberValue{
                if bird.birdIsUnlocked{
                    if bird.birdChallengeType == .TotalTimeSpentInGame{
                        challengeProgressLabel.text = "Time left: 0m"
                    }else{
                        challengeProgressLabel.text = "\(needed) / \(needed)"
                    }
                }else{
                    if bird.birdChallengeType == .TotalTimeSpentInGame {
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
            if bird.neededChallengeBoolValue == bird.currentChallengeBoolValueProgress{
                challengeProgressLabel.text = "Completed"
            }else{
                challengeProgressLabel.text = "Not Completed"
            }
        case .DateValue:
            if let current = bird.currentChallengeDateValueProgress, let needed = bird.neededChallengeDateValue{
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
            challengeTypeLabel.text = ""
            challengeTypeLabel.isHidden = true
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
            challengeProgressLabel.isHidden = true
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
