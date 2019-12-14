//
//  GameViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: BaseViewController {

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: - Properties
    //
    var currentGameScene: BaseSKScene!
    
    //MARK: - Outlets
    //
    @IBOutlet var skView: SKView!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupSKView()
        setupCurrentLevelAndBird()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("GameViewController viewDidAppear called")
        super.viewDidAppear(animated)
        
        showMenuScreen()
        setupCurrentLevelAndBird()
    }
    
    //MARK: - Setup methods
    //
    func setupSKView(){
        skView.ignoresSiblingOrder = true
        
        //TODO: add target(version check) & set below to false on release version
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.showsFields = true
    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupCurrentLevelAndBird), name: .setupCurrentLevelAndBird, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupLevelAndBird(notification:)), name: .setupLevelAndBird, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupCurrentBird), name: .setupCurrentBird, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupBird(notification:)), name: .setupBird, object: nil)
    }
    @objc func setupBird(notification: NSNotification){
        if let bird = notification.object as? Bird{
            setupBird(bird)
        }
    }
    @objc func setupLevelAndBird(notification: NSNotification){
        if let dict = notification.object as? NSDictionary, let level = dict["level"] as? Level, let bird = dict["bird"] as? Bird{
            setupLevelAndBird(level, bird)
        }
    }
    @objc func setupCurrentLevelAndBird(){
        
        let currentLevel = Settings.shared.currentLevel
        let currentBird = Settings.shared.currentBird
        
        setupAudioPlayers(sfxSoundFileName: currentBird.birdSoundFileName, musicSoundFileName: currentLevel.levelMusicSoundFileName)
        
        if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
            currentGameScene = scene as? BaseSKScene
            currentGameScene.currentLevel = currentLevel
            currentGameScene.currentBird = currentBird
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            (scene as? BaseSKScene)?.presentCurrentBird()
        }
    }
    func setupLevelAndBird(_ level: Level, _ bird: Bird){
        
        let currentLevel = level
        let currentBird = bird
        
        setupAudioPlayers(sfxSoundFileName: currentBird.birdSoundFileName, musicSoundFileName: currentLevel.levelMusicSoundFileName)
        
        if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
            currentGameScene = scene as? BaseSKScene
            currentGameScene.currentLevel = currentLevel
            currentGameScene.currentBird = currentBird
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            (scene as? BaseSKScene)?.presentCurrentBird()
        }
    }
    @objc func setupCurrentBird(){
        let currentBird = Settings.shared.currentBird
        setupSFXAudioPlayerWith(currentBirdSoundFileName: currentBird.birdSoundFileName)
        currentGameScene.currentBird = currentBird
        currentGameScene.presentCurrentBird()
    }
    func setupBird(_ bird: Bird){
        setupSFXAudioPlayerWith(currentBirdSoundFileName: bird.birdSoundFileName)
        currentGameScene.currentBird = bird
        currentGameScene.presentCurrentBird()
    }
    
    //TODO: add AdMob setup here
    
    //MARK: - Transition methods
    //
    func showMenuScreen(){
        if let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainMenuScreenIdentifier") as? MainMenuViewController {
            menuVC.gameViewController = self
            self.present(menuVC, animated: true)
        }
    }
    func showPauseScreen(){
        if let pauseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pauseScreenIdentifier") as? PauseViewController {
            pauseVC.gameViewController = self
            self.present(pauseVC, animated: true)
        }
    }
    
    //MARK: - Game methods
    //
    func startGame(_ isCalledFromPauseVC: Bool){
        currentGameScene.startGame()
        if !isCalledFromPauseVC{
            showPauseScreen()
        }
    }
    func pauseGame(){
        currentGameScene.pauseGame()
    }
    func continueGame(){
        currentGameScene.continueGame()
    }
    func stopGame(){
        currentGameScene.stopGame()
    }

}
