//
//  GameViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: BaseAudioViewController {

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
        setupCurrentLevelAndHero()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("GameViewController viewDidAppear called")
        super.viewDidAppear(animated)
        
        showMenuScreen()
        setupCurrentLevelAndHero()
    }
    
    //MARK: - Setup methods
    //
    func setupSKView(){
        skView.ignoresSiblingOrder = true
        
        #if DEBUG
        skView.showsFPS = true
        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.showsFields = true
        #endif
        
    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupCurrentLevelAndHero), name: .setupCurrentLevelAndHero, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupLevelAndHero(notification:)), name: .setupLevelAndHero, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupCurrentHero), name: .setupCurrentHero, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupHero(notification:)), name: .setupHero, object: nil)
    }
    @objc func setupHero(notification: NSNotification){
        if let hero = notification.object as? Hero{
            setupHero(hero)
        }
    }
    @objc func setupLevelAndHero(notification: NSNotification){
        if let dict = notification.object as? NSDictionary, let level = dict["level"] as? Level, let hero = dict["hero"] as? Hero{
            setupLevelAndHero(level, hero)
        }
    }
    @objc func setupCurrentLevelAndHero(){
        
        let currentLevel = Settings.shared.currentLevel
        let currentHero = Settings.shared.currentHero
        
        setupAudioPlayers(sfxSoundFileName: currentLevel.levelMusicSoundFileName, musicSoundFileName: currentLevel.levelMusicSoundFileName)
        
        if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
            currentGameScene = scene as? BaseSKScene
            currentGameScene.currentLevel = currentLevel
            currentGameScene.currentHero = currentHero
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    func setupLevelAndHero(_ level: Level, _ hero: Hero){
        
        let currentLevel = level
        let currentHero = hero
        
        setupAudioPlayers(sfxSoundFileName: currentLevel.levelMusicSoundFileName, musicSoundFileName: currentLevel.levelMusicSoundFileName)

        if let scene = SKScene(fileNamed: currentLevel.levelSceneFileName) {
            currentGameScene = scene as? BaseSKScene
            currentGameScene.currentLevel = currentLevel
            currentGameScene.currentHero = currentHero
            
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    @objc func setupCurrentHero(){
        let currentHero = Settings.shared.currentHero
//        setupSFXAudioPlayerWith(currentBirdSoundFileName: currentHero.birdSoundFileName)
        currentGameScene.currentHero = currentHero
        currentGameScene.setupMainHero()
    }
    func setupHero(_ hero: Hero){
//        setupSFXAudioPlayerWith(currentBirdSoundFileName: hero.birdSoundFileName)
        currentGameScene.currentHero = hero
        currentGameScene.setupMainHero()
    }
    
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
        if !isCalledFromPauseVC{
            showPauseScreen()
        }
        currentGameScene.unhideTapHereContainer()
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
