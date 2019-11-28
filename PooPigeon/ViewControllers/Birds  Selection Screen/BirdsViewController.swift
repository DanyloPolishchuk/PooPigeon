//
//  BirdsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/23/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class BirdsViewController: UIViewController {
    
    //MARK: - Properties
    //
    weak var mainMenuViewController: MainMenuViewController!
    var nextIndexPath: IndexPath?
    var previousIndexPath: IndexPath?
    var nextIsAvaliable = true{
        didSet{
            nextButton.isEnabled = self.nextIsAvaliable
        }
    }
    var previousIsAvaliable = true{
        didSet{
            previousButton.isEnabled = self.previousIsAvaliable
        }
    }
    var currentBirdIsOpened = true{
        didSet{
            checkButton.isEnabled = self.currentBirdIsOpened
        }
    }
    //MARK: - Outlets
    //
    @IBOutlet weak var leftBackButton: UIButton!
    @IBOutlet weak var rightBackButton: UIButton!
    @IBOutlet weak var birdInfoContainerView: UIView!
    @IBOutlet weak var rightGetAllButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var viewUI: UIView!
    
    // non-changable parameters
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    // changable parameters
    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var challengeTypeLabel: UILabel!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    @IBOutlet weak var unlockStatusLabel: UILabel!
    
    // constraints
    @IBOutlet weak var leftBackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightBackButtonConstaint: NSLayoutConstraint!
    @IBOutlet weak var previousButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkButtonConstraint: NSLayoutConstraint!
    
    
    //MARK: - lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaultConstraints()
        setupButtons()
        setupShopView()
        updateBirdScreen()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unhideUI {}
    }
    
    //MARK: - setup methods
    //
    func setupDefaultConstraints(){
        birdInfoContainerView.alpha = 0
        leftBackButtonConstraint.constant = -leftBackButton.frame.width - 8
        rightBackButtonConstaint.constant = -rightBackButton.frame.width - 8
        previousButtonConstraint.constant = -previousButton.frame.width - 8
        nextButtonConstraint.constant = -nextButton.frame.width - 8
        checkButtonConstraint.constant = -checkButton.frame.width - 66
    }
    func setupButtons(){
        let isLeftHandedUI = Settings.shared.isLeftHandedUI
        
        (isLeftHandedUI ? rightBackButton : leftBackButton)?.isHidden = true

        rightGetAllButton.setImage(UIImage(named: "getAllButtonPressed"), for: .highlighted)
        leftBackButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        rightBackButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        previousButton.setImage(UIImage(named: "previousButtonPressed"), for: .highlighted)
        nextButton.setImage(UIImage(named: "rightArrowButtonPressed"), for: .highlighted)
        checkButton.setImage(UIImage(named: "checkButtonPressed"), for: .highlighted)
        
    }
    func setupShopView(){
        self.bestScoreLabel.text = String(Settings.shared.bestScore)
        self.totalScoreLabel.text = String(Settings.shared.totalScore)
    }
    func setupButtonEnabledStatuses(){
        
        var currentlyPresentedLevelIndex = 0
        var currentlyPresentedBirdIndex = 0
        if let currentBirdNumber = mainMenuViewController.currentGameScene.currentBird?.birdNumber, let currentLevelNumer = mainMenuViewController.currentGameScene.currentLevel?.levelNumber {
            currentlyPresentedBirdIndex = currentBirdNumber - 1
            currentlyPresentedLevelIndex = currentLevelNumer - 1
        }
        nextIndexPath = Settings.shared.getNext(forLevelAtIndex: currentlyPresentedLevelIndex, forBirdAtIndex: currentlyPresentedBirdIndex)
        previousIndexPath = Settings.shared.getPrevious(forLevelAtIndex: currentlyPresentedLevelIndex, forBirdAtIndex: currentlyPresentedBirdIndex)
        nextIsAvaliable = nextIndexPath != nil
        previousIsAvaliable = previousIndexPath != nil
        if let currentBirdIsOpened = mainMenuViewController.currentGameScene.currentBird?.birdIsUnlocked{
            self.currentBirdIsOpened = currentBirdIsOpened
        }

    }

    func setupCurrentlyPresentedBirdInfo(){
        if let bird = mainMenuViewController.currentGameScene.currentBird{
            let birdName = bird.birdName
            let birdChallengeType = bird.birdChallengeType.rawValue
            var birdChallengeProgress = ""
            
            switch bird.birdChallengeType {
            case .None:
                birdChallengeProgress = ""
            case .BestScore:
                birdChallengeProgress = "\(Settings.shared.bestScore) / \(bird.neededChallengeNumberValue)"
            case .TotalScore:
                birdChallengeProgress = "\(Settings.shared.totalScore) / \(bird.neededChallengeNumberValue)"
            case .TotalLoseTimes:
                birdChallengeProgress = "\(Settings.shared.amountOfLoses) / \(bird.neededChallengeNumberValue)"
            case .TotalTimeSpentInGame:
                birdChallengeProgress = "\(Settings.shared.timeInSecsSpentInGame) / \(bird.neededChallengeNumberValue)"
            case .TotalDaysGameWasLaunched:
                birdChallengeProgress = "\(Settings.shared.amountOfDaysGameWasLaunched) / \(bird.neededChallengeNumberValue)"
            case .TotalTimesGameWasLaunched:
                birdChallengeProgress = "\(Settings.shared.timesGameWasLaunched) / \(bird.neededChallengeNumberValue)"
            case .LikeUs:
                birdChallengeProgress = Settings.shared.isApplicationLiked ? "Done" : "Not Liked"
            case .ShareUs:
                birdChallengeProgress = Settings.shared.isApplicaitonShared ? "Done" : "Not Shared"
            case .ReviewUs:
                birdChallengeProgress = Settings.shared.isApplicationReviewed ? "Done" : "Not Reviewed"
            case .UniqueLaunchDay:
                //TODO: implement unique date challenge parsing ?
                birdChallengeProgress = ""
            }
            let birdIsUnlocked = bird.birdIsUnlocked ? "Unlocked" : "Locked"
            
            birdNameLabel.text = birdName
            challengeTypeLabel.text = birdChallengeType
            challengeProgressLabel.text = birdChallengeProgress
            unlockStatusLabel.text = birdIsUnlocked
        }
    }
    func updateBirdScreen(){
        setupCurrentlyPresentedBirdInfo()
        setupButtonEnabledStatuses()
    }
    
    //MARK: - animations methods
    //
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.birdInfoContainerView.alpha = 0
            self.leftBackButtonConstraint.constant = -self.leftBackButton.frame.width - 8
            self.rightBackButtonConstaint.constant = -self.rightBackButton.frame.width - 8
            self.previousButtonConstraint.constant = -self.previousButton.frame.width - 8
            self.nextButtonConstraint.constant = -self.nextButton.frame.width - 8
            self.checkButtonConstraint.constant = -self.checkButton.frame.width - 66
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func unhideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.birdInfoContainerView.alpha = 1.0
            self.leftBackButtonConstraint.constant = 8
            self.rightBackButtonConstaint.constant = 8
            self.previousButtonConstraint.constant = 8
            self.nextButtonConstraint.constant = 8
            self.checkButtonConstraint.constant = 16
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func backAction(_ sender: Any) {
        hideUI {
            self.dismiss(animated: true, completion: {
                self.mainMenuViewController.viewDidAppear(true)
            })
        }
    }
    @IBAction func getAllAction(_ sender: Any) {
        //TODO: implement Inn-App Purchase here (IAP)
    }
    @IBAction func checkAction(_ sender: Any) {
        // change current bird & / level
        // or do nothing if bird is not unlocked
        // or work as back if bird is not changed
        
        // update current bird & / level in Settings
        // back
        Settings.shared.currentBird = mainMenuViewController.currentGameScene.currentBird
        Settings.shared.currentLevel = mainMenuViewController.currentGameScene.currentLevel
        Settings.shared.save()
        
        hideUI {
            self.dismiss(animated: true, completion: {
                self.mainMenuViewController.viewDidAppear(true)
            })
        }
    }
    @IBAction func previousAction(_ sender: Any) {
        if let indexPath = previousIndexPath {
            let level = Settings.shared.getLevelAtIndex(index: indexPath.row)
            let bird = level?.birds[indexPath.section]
            if let level = level, let bird = bird {
                mainMenuViewController.setupLevelAndBird(level, bird)
                updateBirdScreen()
            }
        }
    }
    @IBAction func nextAction(_ sender: Any) {
        if let indexPath = nextIndexPath {
            let level = Settings.shared.getLevelAtIndex(index: indexPath.row)
            let bird = level?.birds[indexPath.section]
            if let level = level, let bird = bird {
                mainMenuViewController.setupLevelAndBird(level, bird)
                updateBirdScreen()
            }
        }
    }
}
