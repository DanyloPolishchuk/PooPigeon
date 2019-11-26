//
//  GameViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/23/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

//TODO: make gameScene accesible globally through settings ? if possible & if needed

class GameViewController: UIViewController {
    
    //MARK: - Properties
    //
    weak var mainMenuViewController: MainMenuViewController!
    var isTopButtonAPauseButton = true
    
    //MARK: - Outlets
    //
    @IBOutlet weak var leftPauseButton: UIButton!
    @IBOutlet weak var rightPauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var backgroundView: UIView! // alpha 0.33 - 0.0
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    //constraints
    @IBOutlet weak var leftPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabelConstraint: NSLayoutConstraint!
    
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaultConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        unhideUI {}
    }
    
    //MARK: - setup methods
    //
    func setupDefaultConstraints(){
        self.leftPauseButtonConstraint.constant = -self.leftPauseButton.frame.width - 8
        self.rightPauseButtonConstraint.constant = -self.rightPauseButton.frame.width - 8
        self.scoreLabelConstraint.constant = -100
    }
    func setupPauseButton(){
        leftPauseButton.setImage(UIImage(named: "pauseButtonNormal"), for: .normal)
        leftPauseButton.setImage(UIImage(named: "pauseButtonPressed"), for: .highlighted)
        rightPauseButton.setImage(UIImage(named: "pauseButtonNormal"), for: .normal)
        rightPauseButton.setImage(UIImage(named: "pauseButtonPressed"), for: .highlighted)
    }
    func setupBackButton(){
        leftPauseButton.setImage(UIImage(named: "backButtonNormal"), for: .normal)
        leftPauseButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        rightPauseButton.setImage(UIImage(named: "backButtonNormal"), for: .normal)
        rightPauseButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
    }
    func setupPauseView(){
        // music & sound button states
    }
    func setupGameOverView(){
        // score & total
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
    func showPauseView(){
        UIView.animate(withDuration: 0.25) {
            self.pauseView.alpha = 1.0
            self.viewUI.layoutIfNeeded()
        }
    }
    func hidePauseView(){
        UIView.animate(withDuration: 0.25) {
            self.pauseView.alpha = 0.0
            self.viewUI.layoutIfNeeded()
        }
    }
    func showGameOverView(){
        //TODO: rewrite so it setups topButton, run animation & presents gameOverView
        UIView.animate(withDuration: 0.25) {
            self.gameOverView.alpha = 1.0
            self.viewUI.layoutIfNeeded()
        }
    }
    func hideGameOverView(){
        //TODO: rewrite so it is as the method above but reversed
        UIView.animate(withDuration: 0.25) {
            self.gameOverView.alpha = 0.0
            self.viewUI.layoutIfNeeded()
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func pauseOrBackAction(_ sender: UIButton) {
        
        if isTopButtonAPauseButton{
            // pause  scene
            // show pause view
        }else{
            // dismiss VC func
        }
    }
    @IBAction func playAction(_ sender: UIButton) {
        // unpause whole scene
    }
    @IBAction func homeAction(_ sender: Any) {
        // dismiss VC func
    }
    @IBAction func soundAction(_ sender: Any) {
        // sound call to the scene
    }
    @IBAction func musicAction(_ sender: Any) {
        // music call to the scenes
    }
    
    
}
