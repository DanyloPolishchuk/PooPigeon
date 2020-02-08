//
//  PauseViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class PauseViewController: BaseBannerAdViewController {
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: - Properties
    //
    weak var gameViewController: GameViewController!
    var isTopButtonAPauseButton = true
    
    //MARK: - Outlets
    //
    @IBOutlet weak var viewUI: UIView!

    @IBOutlet weak var leftPauseButton: UIButton!
    @IBOutlet weak var rightPauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var sfxButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var playButtonPause: UIButton!
    
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var playButtonGameOver: UIButton!
    
    //constraints
    @IBOutlet weak var leftPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabelConstraint: NSLayoutConstraint!
    
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streakLabel.isHidden = true
        streakLabel.text = "x1"
        
        setupNotifications()
        setupDefaultConstraints()
        setupPauseView()
        
        let isLeftHandedUI = Settings.shared.isLeftHandedUI
        (isLeftHandedUI ? rightPauseButton : leftPauseButton)?.isHidden = true
        (isLeftHandedUI ? leftPauseButton : rightPauseButton)?.isHidden = false
        
        self.pauseView.alpha = 0.0
        self.gameOverView.alpha = 0.0
        self.backgroundView.alpha = 0.0
        
        setupPlayButtons()
        setupGameOverView()
        setupPauseButton()
        setupScoreAndStreakLabelAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        unhideUI {}
    }
    
    //MARK: - setup methods
    //
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupScoreLabel(notification:)), name: .setupScoreKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupStreakLabel(notification:)), name: .setupStreak, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetScoreAndStreakLabels), name: .resetScoreAndStreak, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGameOverView(notification:)), name: .showGameOverKey, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseOnResignActive), name: .pauseOnResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unpauseOnDidBecomeActive), name: .unpauseOnDidBecomeActive, object: nil)
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
        setupSFXButton()
        setupMusicButton()
        setupHomeButton()
    }
    func setupSFXButton(){
        let isSoundEffectsEnabled = Settings.shared.isSoundEffectsEnabled
        sfxButton.setImage(UIImage(named: isSoundEffectsEnabled ? "sfxOnButtonNormal" : "sfxOffButtonNormal"), for: .normal)
        sfxButton.setImage(UIImage(named: isSoundEffectsEnabled ? "sfxOnButtonPressed" : "sfxOffButtonPressed"), for: .highlighted)
    }
    func setupMusicButton(){
        let isMusicEnabled = Settings.shared.isMusicEnabled
        musicButton.setImage(UIImage(named: isMusicEnabled ? "musicOnButtonNormal" : "musicOffButtonNormal" ), for: .normal)
        musicButton.setImage(UIImage(named: isMusicEnabled ? "musicOnButtonPressed" : "musicOffButtonPressed"), for: .highlighted)
    }
    func setupHomeButton(){
        homeButton.setImage(UIImage(named: "homeButtonNormal"), for: .normal)
        homeButton.setImage(UIImage(named: "homeButtonPressed"), for: .highlighted)

    }
    func setupGameOverView(){
        bestScoreLabel.text = String(Settings.shared.bestScore)
        totalScoreLabel.text = String(Settings.shared.totalScore)
    }
    func setupScoreAndStreakLabelAnimations(){
        scoreLabel.layer.shadowColor = UIColor.white.cgColor
        scoreLabel.layer.shadowOffset = .zero
        scoreLabel.layer.shadowRadius = 10 
        scoreLabel.layer.shadowOpacity = 1.0
        scoreLabel.layer.masksToBounds = false
        
        streakLabel.layer.shadowColor = UIColor.white.cgColor
        streakLabel.layer.shadowOffset = .zero
        streakLabel.layer.shadowRadius = 10
        streakLabel.layer.shadowOpacity = 1.0
        streakLabel.layer.masksToBounds = false
    }
    
    //MARK: - Notification methods
    //
    @objc func setupScoreLabel(notification: NSNotification){
        if let score = notification.object as? UInt{
            scoreLabel.text = String(score)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (animationFinishedBeforeCompletion) in
            UIView.animate(withDuration: 0.2, animations: {
                self.scoreLabel.transform = .identity
            })
        }
        
    }
    @objc func setupStreakLabel(notification: NSNotification){
        streakLabel.isHidden = false
        if let streak = notification.object as? Int{
            streakLabel.text = "x" + String(streak)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.streakLabel.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (animationFinishedBeforeCompletion) in
            UIView.animate(withDuration: 0.2, animations: {
                self.streakLabel.transform = .identity
            })
        }
    }
    @objc func resetScoreAndStreakLabels(){
        scoreLabel.text = "0"
        streakLabel.isHidden = true
        streakLabel.text = "x1"
    }
    @objc func showGameOverView(notification: NSNotification){
        showGameOverView()
    }
    @objc func pauseOnResignActive(){
        gameViewController.pauseGame()
        showPauseView()
    }
    @objc func unpauseOnDidBecomeActive(){
        gameViewController.continueGame()
        hidePauseView()
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
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        
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
        NotificationCenter.default.post(name: .buttonPressed, object: nil)

        if sender.tag == 0 { // pause view
            hidePauseView()
            gameViewController.continueGame()
        }else if sender.tag == 1 { // game over view
            hideGameOverView()
            gameViewController.startGame(true)
        
        }
    }
    @IBAction func homeAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)

        gameViewController.stopGame()
        hideAllUI {
            self.dismiss(animated: true, completion: {
                self.gameViewController.viewDidAppear(true)
            })
        }
    }
    @IBAction func soundAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)

        let isSFXEnabled = Settings.shared.isSoundEffectsEnabled
        Settings.shared.isSoundEffectsEnabled = !isSFXEnabled
        Settings.shared.save()
        setupSFXButton()
        NotificationCenter.default.post(name: isSFXEnabled ? .turnSFXOff : .turnSFXOn , object: nil)
    }
    @IBAction func musicAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)

        let isMusicEnabled = Settings.shared.isMusicEnabled
        Settings.shared.isMusicEnabled = !isMusicEnabled
        Settings.shared.save()
        setupMusicButton()
        NotificationCenter.default.post(name: isMusicEnabled ? .turnMusicOff : .turnMusicOn, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        gameViewController.currentGameScene.touchesBegan(touches, with: event)
    }
    
}
