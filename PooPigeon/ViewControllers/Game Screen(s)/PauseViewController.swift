//
//  PauseViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    
    //MARK: - Properties
    //
    weak var gameViewController: GameViewController!
    var isTopButtonAPauseButton = true
    
    //MARK: - Outlets
    //
    @IBOutlet weak var leftPauseButton: UIButton!
    @IBOutlet weak var rightPauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var playButtonGameOver: UIButton!
    @IBOutlet weak var playButtonPause: UIButton!
    //constraints
    @IBOutlet weak var leftPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabelConstraint: NSLayoutConstraint!
    
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupDefaultConstraints()
        setupPauseView()
        (Settings.shared.isLeftHandedUI ? rightPauseButton : leftPauseButton)?.isHidden = true
        
        self.pauseView.alpha = 0.0
        self.gameOverView.alpha = 0.0
        self.backgroundView.alpha = 0.0
        
        setupPlayButtons()
        setupGameOverView()
        setupPauseButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        unhideUI {}
    }
    
    //MARK: - setup methods
    //
    func setupScoreLabelWithValue(_ value: UInt){
        scoreLabel.text = String(value)
    }
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupScoreLabel(notification:)), name: .setupScoreKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGameOverView(notification:)), name: .showGameOverKey, object: nil)
    }
    func setupDefaultConstraints(){
        self.leftPauseButtonConstraint.constant = -self.leftPauseButton.frame.width - 8
        self.rightPauseButtonConstraint.constant = -self.rightPauseButton.frame.width - 8
        self.scoreLabelConstraint.constant = -100
    }
    func setupPlayButtons(){
        playButtonGameOver.setImage(UIImage(named: "playButtonPressed"), for: .highlighted)
        playButtonPause.setImage(UIImage(named: "playButtonPressed"), for: .highlighted)
    }
    func setupPauseButton(){
        isTopButtonAPauseButton = true
        leftPauseButton.setImage(UIImage(named: "pauseButtonNormal"), for: .normal)
        leftPauseButton.setImage(UIImage(named: "pauseButtonPressed"), for: .highlighted)
        rightPauseButton.setImage(UIImage(named: "pauseButtonNormal"), for: .normal)
        rightPauseButton.setImage(UIImage(named: "pauseButtonPressed"), for: .highlighted)
    }
    func setupBackButton(){
        isTopButtonAPauseButton = false
        leftPauseButton.setImage(UIImage(named: "backButtonNormal"), for: .normal)
        leftPauseButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        rightPauseButton.setImage(UIImage(named: "backButtonNormal"), for: .normal)
        rightPauseButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
    }
    func setupPauseView(){
        setupMusicButton()
        setupSFXButton()
        //TODO: add home button setup
    }
    func setupMusicButton(){
        //TODO: implement music button images setup
    }
    func setupSFXButton(){
        //TODO: implement SFX button images setup
    }
    func setupGameOverView(){
        bestScoreLabel.text = String(Settings.shared.bestScore)
        totalScoreLabel.text = String(Settings.shared.totalScore)
    }
    
    //MARK: - Notification methods
    //
    @objc func setupScoreLabel(notification: NSNotification){
        if let score = notification.object as? UInt{
            scoreLabel.text = String(score)
        }
    }
    @objc func showGameOverView(notification: NSNotification){
        showGameOverView()
    }
    
    //MARK: - Animation methods
    //
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftPauseButtonConstraint.constant = -self.leftPauseButton.frame.width - 8
            self.rightPauseButtonConstraint.constant = -self.rightPauseButton.frame.width - 8
            self.scoreLabelConstraint.constant = -100
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    func unhideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftPauseButtonConstraint.constant = 8
            self.rightPauseButtonConstraint.constant = 8
            self.scoreLabelConstraint.constant = 8
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    func hideAllUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftPauseButtonConstraint.constant = -self.leftPauseButton.frame.width - 8
            self.rightPauseButtonConstraint.constant = -self.rightPauseButton.frame.width - 8
            self.scoreLabelConstraint.constant = -100
            
            self.pauseView.alpha = 0.0
            self.gameOverView.alpha = 0.0
            self.backgroundView.alpha = 0.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    func hideTopButton(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.125, animations: {
            self.leftPauseButtonConstraint.constant = -self.leftPauseButton.frame.width - 8
            self.rightPauseButtonConstraint.constant = -self.rightPauseButton.frame.width - 8
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    func unhideTopButton(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.125, animations: {
            self.leftPauseButtonConstraint.constant = 8
            self.rightPauseButtonConstraint.constant = 8
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func showPauseView(){
        setupPauseView()
        UIView.animate(withDuration: 0.25, animations: {
            self.pauseView.alpha = 1.0
            self.backgroundView.alpha = 0.33
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            self.leftPauseButton.isEnabled = false
            self.rightPauseButton.isEnabled = false
        }
    }
    func hidePauseView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.pauseView.alpha = 0.0
            self.backgroundView.alpha = 0.0
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            self.leftPauseButton.isEnabled = true
            self.rightPauseButton.isEnabled = true
        }
    }
    func showGameOverView(){
        self.setupGameOverView()
        hideTopButton {
            self.setupBackButton()
            UIView.animate(withDuration: 0.25) {
                self.gameOverView.alpha = 1.0
                self.backgroundView.alpha = 0.33
                self.viewUI.layoutIfNeeded()
            }
            self.unhideTopButton {}
        }
    }
    func hideGameOverView(){
        hideTopButton {
            self.setupPauseButton()
            UIView.animate(withDuration: 0.25) {
                self.gameOverView.alpha = 0.0
                self.backgroundView.alpha = 0.0
                self.viewUI.layoutIfNeeded()
            }
            self.unhideTopButton {}
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func pauseOrBackAction(_ sender: UIButton) {
        if isTopButtonAPauseButton{
            gameViewController.pauseGame()
            showPauseView()
        }else{
            gameViewController.stopGame()
            hideAllUI {
                self.dismiss(animated: true, completion: {
                    self.gameViewController.viewDidAppear(true)
                })
            }
        }
    }
    @IBAction func playAction(_ sender: UIButton) {
        if sender.tag == 0 { // pause view
            hidePauseView()
            gameViewController.continueGame()
        }else if sender.tag == 1 { // game over view
            setupScoreLabelWithValue(0)
            hideGameOverView()
            gameViewController.startGame(true)
        
        }
    }
    @IBAction func homeAction(_ sender: Any) {
        gameViewController.stopGame()
        hideAllUI {
            self.dismiss(animated: true, completion: {
                self.gameViewController.viewDidAppear(true)
            })
        }
    }
    @IBAction func soundAction(_ sender: Any) {
        // sound call to the scene
        if Settings.shared.isSoundEffectsEnabled {
            gameViewController.turnSFXOff()
            //TODO: update button images
        }else{
            gameViewController.turnSFXOn()
            //TODO: update button images
        }
    }
    @IBAction func musicAction(_ sender: Any) {
        // music call to the scenes
        if Settings.shared.isMusicEnabled {
            gameViewController.turnMusicOff()
            //TODO: update button images
        }else{
            gameViewController.turnMusicOn()
            //TODO: update button images
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        gameViewController.currentGameScene.touchesBegan(touches, with: event)
    }
    
}
