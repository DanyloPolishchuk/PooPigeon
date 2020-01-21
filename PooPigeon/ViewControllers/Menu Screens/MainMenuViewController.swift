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
import GoogleMobileAds

class MainMenuViewController: BaseBannerAdViewController {
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: - Properties
    //
    weak var gameViewController: GameViewController!
    private var isLeftHandedUI: Bool!
    
    //MARK: - Outlets
    //
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    // constraints
    @IBOutlet weak var topLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonConstraint: NSLayoutConstraint!
    
    //MARK: - lifecylce methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainMenuViewController viewWillAppear called")
        setupDefaultConstraints()
        setupButtons()
        setupTutorialButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupButtons()
        unhideBannerView()
        unhideUI {}
    }
    
    //MARK: - Setup methods
    //
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
        
        tutorialButton.setImage(UIImage(named: "tutorialButtonPressed"), for: .highlighted)
        
        self.isLeftHandedUI = Settings.shared.isLeftHandedUI
        
        (isLeftHandedUI ? rightTopButton : leftTopButton)?.isHidden = true
        (isLeftHandedUI ? leftTopButton : rightTopButton)?.isHidden = false
        
        
        rightBottomButton.setImage(UIImage(named: isLeftHandedUI ? "achievementsButtonPressed" : "pigeonButtonPressed" ), for: .highlighted)
        leftBottomButton.setImage(UIImage(named: isLeftHandedUI ? "pigeonButtonPressed" : "achievementsButtonPressed" ), for: .highlighted)
        rightBottomButton.setImage(UIImage(named: isLeftHandedUI ? "achievementsButtonNormal" : "pigeonButtonNormal" ), for: .normal)
        leftBottomButton.setImage(UIImage(named: isLeftHandedUI ? "pigeonButtonNormal" : "achievementsButtonNormal" ), for: .normal)
    }
    func setupTutorialButton(){
        let shouldShowTutorial = Settings.shared.isTutorialSupposedToBeShown
        tutorialButton.isHidden = !shouldShowTutorial
        if shouldShowTutorial {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction ,.repeat, .autoreverse, .beginFromCurrentState], animations: {
                self.tutorialButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }) { (animationsFinishedBeforeCompletion) in
                self.tutorialButton.transform = .identity
            }
        }
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
        if let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsScreenIdentifier") as? SettingsViewController{
            settingsVC.mainMenuViewConroller = self
            self.present(settingsVC, animated: true)
        }
    }
    func showShop(){
        if let shopVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "birdsScreenIdentifier") as? ShopViewController {
            shopVC.mainMenuViewController = self
            self.present(shopVC, animated: true)
        }
    }
    func showAchievements(){
        if let achievementsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "achievementsScreenIdentifier") as? AchievementsViewController {
            achievementsVC.mainMenuViewCotnroller = self
            self.present(achievementsVC, animated: true)
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func playAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        hideBannerView()
        hideUI {
            self.dismiss(animated: true, completion: {
                self.gameViewController.startGame(false)
            })
        }
    }
    @IBAction func rightBottomAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        hideBannerView()
        hideUI {
            if self.isLeftHandedUI{
                self.showAchievements()
            }else{
                self.showShop()
            }
        }
    }
    @IBAction func leftBottomAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        hideBannerView()
        hideUI {
            if self.isLeftHandedUI{
                self.showShop()
            }else{
                self.showAchievements()
            }
        }
    }
    @IBAction func settingsAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        hideBannerView()
        hideUI {
            self.showSettings()
        }
    }
    @IBAction func tutorialAction(_ sender: Any) {
        if let tutorialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialScreenStoryboardID") as? TutorialViewController{
            tutorialVC.mainMenuViewController = self
            self.present(tutorialVC, animated: true)
        }
    }
    
    
}
