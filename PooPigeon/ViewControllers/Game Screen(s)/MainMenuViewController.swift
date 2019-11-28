//
//  MainMenuViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/23/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MainMenuViewController: UIViewController {
    
    //MARK: - Properties
    //
    private var currentLevelNumber: Int!
    private var currentLevel: Level!
    var currentGameScene: BaseSKScene!
    private var isLeftHandedUI: Bool!
    
    //MARK: - Outlets
    //
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    // constraints
    @IBOutlet weak var topLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonConstraint: NSLayoutConstraint!
    
    //MARK: - Overriden Properties
    //
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: - lifecylce methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCurrentLevelAndBird()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDefaultConstraints()
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentGameScene.viewController = self
        setupCurrentLevelAndBird()
        unhideUI {}
    }
    
    //MARK: - Setup methods
    //
    func setupCurrentLevelAndBird(){
        
        let currentLevel = Settings.shared.currentLevel
        let currentBird = Settings.shared.currentBird
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
                currentGameScene = scene as? BaseSKScene
                currentGameScene.viewController = self
                currentGameScene.currentLevel = currentLevel
                currentGameScene.currentBird = currentBird

                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true

            view.showsFPS = true
            view.showsPhysics = true
            view.showsNodeCount = true
            view.showsFields = true
        }
    }
    func setupLevelAndBird(_ level: Level, _ bird: Bird){
        
        let currentLevel = level
        let currentBird = bird
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
                currentGameScene = scene as? BaseSKScene
                currentGameScene.viewController = self
                currentGameScene.currentLevel = currentLevel
                currentGameScene.currentBird = currentBird
                
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsPhysics = true
            view.showsNodeCount = true
            view.showsFields = true
        }
    }
    
    func setupDefaultConstraints(){
        self.topLeftButtonConstraint.constant = -self.leftTopButton.frame.width - 8
        self.topRightButtonConstraint.constant = -self.rightTopButton.frame.width - 8
        self.bottomLeftButtonConstraint.constant = -self.leftBottomButton.frame.width - 8
        self.bottomRightButtonConstraint.constant = -self.rightBottomButton.frame.width - 8
        self.playButtonConstraint.constant = -self.playButton.frame.height - 66
        self.logoImageView.alpha = 0.0
    }
    func setupButtons(){
        rightTopButton.setImage(UIImage(named: "settingsButtonPressed"), for: .highlighted)
        leftTopButton.setImage(UIImage(named: "settingsButtonPressed"), for: .highlighted)
        playButton.setImage(UIImage(named: "playButtonPressed"), for: .highlighted)
        
        
        self.isLeftHandedUI = Settings.shared.isLeftHandedUI
        (isLeftHandedUI ? rightTopButton : leftTopButton)?.isHidden = true
        
        rightBottomButton.setImage(UIImage(named: isLeftHandedUI ? "achievementsButtonPressed" : "pigeonButtonPressed" ), for: .highlighted)
        leftBottomButton.setImage(UIImage(named: isLeftHandedUI ? "pigeonButtonPressed" : "achievementsButtonPressed" ), for: .highlighted)
        rightBottomButton.setImage(UIImage(named: isLeftHandedUI ? "achievementsButtonNormal" : "pigeonButtonNormal" ), for: .normal)
        leftBottomButton.setImage(UIImage(named: isLeftHandedUI ? "pigeonButtonNormal" : "achievementsButtonNormal" ), for: .normal)
    }
    
    //MARK: - Animation methods
    //
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.topLeftButtonConstraint.constant = -self.leftTopButton.frame.width - 8
            self.topRightButtonConstraint.constant = -self.rightTopButton.frame.width - 8
            self.bottomLeftButtonConstraint.constant = -self.leftBottomButton.frame.width - 8
            self.bottomRightButtonConstraint.constant = -self.rightBottomButton.frame.width - 8
            self.playButtonConstraint.constant = -self.playButton.frame.height - 66
            self.logoImageView.alpha = 0.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func unhideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.topLeftButtonConstraint.constant = 8
            self.topRightButtonConstraint.constant = 8
            self.bottomLeftButtonConstraint.constant = 8
            self.bottomRightButtonConstraint.constant = 8
            self.playButtonConstraint.constant = 66
            self.logoImageView.alpha = 1.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    //MARK: - Show another screens methods
    //
    func showSettings(){
        
    }
    func showBirds(){
        if let birdsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "birdsScreenIdentifier") as? BirdsViewController {
            birdsVC.mainMenuViewController = self
            self.present(birdsVC, animated: true)
        }
    }
    func showAchievements(){
        
    }
    func showGameScreen(){
        // gameScreenIdentifier
        if let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameScreenIdentifier") as? GameViewController {
            gameVC.mainMenuViewController = self
            self.currentGameScene.viewController = gameVC
            self.present(gameVC, animated: true)
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func playAction(_ sender: Any) {
        hideUI {
            //TODO: enable touch events on scene & start enemy spawning e.t.c, some kind of startLevel() method. Scene should not be paused in the BG.
            self.currentGameScene.levelIsInGameState = true
            self.showGameScreen()
        }
    }
    @IBAction func rightBottomAction(_ sender: UIButton) {
        hideUI {
            if self.isLeftHandedUI{
                self.showAchievements()
            }else{
                self.showBirds()
            }
        }
    }
    @IBAction func leftBottomAction(_ sender: UIButton) {
        hideUI {
            if self.isLeftHandedUI{
                self.showBirds()
            }else{
                self.showAchievements()
            }
        }
    }
    @IBAction func settingsAction(_ sender: UIButton) {
        hideUI {
            self.showSettings()
        }
    }
    
    
}
