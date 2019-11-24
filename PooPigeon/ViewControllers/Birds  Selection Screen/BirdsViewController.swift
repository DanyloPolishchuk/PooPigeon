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
    weak var gameVC: MainMenuViewController!
    // add reference to the mainVC / directly to the scene ?
    
    //MARK: - Outlets
    //
    @IBOutlet weak var leftBackButton: UIButton!
    @IBOutlet weak var rightBackButton: UIButton!
    @IBOutlet weak var birdInfoContainerView: UIView!
    @IBOutlet weak var leftGetAllButton: UIButton!
    @IBOutlet weak var rightGetAllButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var viewUI: UIView!
    // constraints
    @IBOutlet weak var leftBackButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightBackButtonConstaint: NSLayoutConstraint!
    @IBOutlet weak var leftGetAllButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightGetAllButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var previousButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkButtonConstraint: NSLayoutConstraint!
    
    
    //MARK: - lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaultConstraints()
        setupButtons()
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
        leftGetAllButtonConstraint.constant = -leftGetAllButton.frame.width - 8
        rightGetAllButtonConstraint.constant = -rightGetAllButton.frame.width - 8
        previousButtonConstraint.constant = -previousButton.frame.width - 8
        nextButtonConstraint.constant = -nextButton.frame.width - 8
        checkButtonConstraint.constant = -checkButton.frame.width - 66
    }
    func setupButtons(){
        let isLeftHandedUI = Settings.shared.isLeftHandedUI
        
        (isLeftHandedUI ? rightBackButton : leftBackButton)?.isHidden = true
        (isLeftHandedUI ? rightGetAllButton : leftGetAllButton)?.isHidden = true

        leftGetAllButton.setImage(UIImage(named: "getAllButtonPressed"), for: .highlighted)
        rightGetAllButton.setImage(UIImage(named: "getAllButtonPressed"), for: .highlighted)
        leftBackButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        rightBackButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        previousButton.setImage(UIImage(named: "previousButtonPressed"), for: .highlighted)
        nextButton.setImage(UIImage(named: "rightArrowButtonPressed"), for: .highlighted)
        checkButton.setImage(UIImage(named: "checkButtonPressed"), for: .highlighted)
        
    }
    //MARK: - animations methods
    //
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.birdInfoContainerView.alpha = 0
            self.leftBackButtonConstraint.constant = -self.leftBackButton.frame.width - 8
            self.rightBackButtonConstaint.constant = -self.rightBackButton.frame.width - 8
            self.leftGetAllButtonConstraint.constant = -self.leftGetAllButton.frame.width - 8
            self.rightGetAllButtonConstraint.constant = -self.rightGetAllButton.frame.width - 8
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
            self.leftGetAllButtonConstraint.constant = 8
            self.rightGetAllButtonConstraint.constant = 8
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
//            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: {
                self.gameVC.viewDidAppear(true)
            })
        }
    }
    @IBAction func getAllAction(_ sender: Any) {
        //TODO: implements Inn-App Purchase here (IAP)
    }
    @IBAction func checkAction(_ sender: Any) {
    }
    @IBAction func previousAction(_ sender: Any) {
    }
    @IBAction func nextAction(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
