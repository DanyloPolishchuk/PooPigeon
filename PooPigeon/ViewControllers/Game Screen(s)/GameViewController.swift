//
//  GameViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

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
    func setupCurrentLevelAndBird(){
        
        let currentLevel = Settings.shared.currentLevel
        let currentBird = Settings.shared.currentBird
        
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
        
        if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
            currentGameScene = scene as? BaseSKScene
            currentGameScene.currentLevel = currentLevel
            currentGameScene.currentBird = currentBird
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            (scene as? BaseSKScene)?.presentCurrentBird()
        }
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
    func turnMusicOn(){
        currentGameScene.turnMusicOn()
    }
    func turnMusicOff(){
        currentGameScene.turnMusicOff()
    }
    func turnSFXOn(){
        currentGameScene.turnSFXOn()
    }
    func turnSFXOff(){
        currentGameScene.turnSFXOff()
    }

}
