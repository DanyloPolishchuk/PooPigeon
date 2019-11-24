//
//  GameViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/23/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

//TODO: maybe combine gameVC screen (pause screen) with game Over screen, it's just 1 more view in center
//TODO: make gameScene accesible globally through settings ? if possible & if needed

class GameViewController: UIViewController {
    
    //MARK: - Properties
    //
    
    //MARK: - Outlets
    //
    @IBOutlet weak var leftPauseButton: UIButton!
    @IBOutlet weak var rightPauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseView: UIView!
    //constraints
    @IBOutlet weak var leftPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPauseButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLabelConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}
