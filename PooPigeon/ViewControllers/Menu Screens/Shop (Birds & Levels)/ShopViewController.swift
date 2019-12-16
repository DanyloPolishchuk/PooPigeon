//
//  ShopViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/13/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

//TODO: add last cell as "Get All Birds / Levels" cell

import UIKit

class ShopViewController: UIViewController {
    
    //MARK: - Properties
    //
    var birds: [Bird]?
    var levels: [Level]?
    
    var isFirstSelectedBirdIndexPathSetCall = true
    var isFirstSelectedLevelIndexPathSetCall = true
    var selectedBirdIndexPath: IndexPath?
    var selectedLevelIndexPath: IndexPath?
    
    let birdCellReuseIdentifier = "birdCellReuseIdentifier"
    let levelCellReuseIdentifier = "levelCellReuseIdentifier"
    
    weak var mainMenuViewController: MainMenuViewController!
    
    var isUIHiddenForPreview = false
    
    //MARK: - Outlets
    //
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var previewButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewsContainerView: UIView!
    @IBOutlet weak var birdsCollectionView: UICollectionView!
    @IBOutlet weak var levelsCollectionView: UICollectionView!
    

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopButtons()
        setupDefaultConstraints()
        updateDataSources()
        setupDataSources()
        setupCollectionViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unhideUI {
            self.setupDefaultSelectedCells()
        }
    }
    
    //MARK: - Setup methods
    //
    func setupTopButtons(){
        backButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        previewButton.setImage(UIImage(named: "previewButtonPressed"), for: .highlighted)
    }
    func setupDefaultConstraints(){
        self.backButtonConstraint.constant = -self.backButton.frame.width - 8
        self.previewButtonConstraint.constant = -self.previewButton.frame.width - 8
        self.collectionViewsContainerView.alpha = 0.0
    }
    func updateDataSources(){
        Settings.shared.updateCurrentProgressProperties()
    }
    func setupDataSources(){
        self.birds = Settings.shared.getBirds()
        self.levels = Settings.shared.getLevels()
    }
    func setupCollectionViews(){
        birdsCollectionView.delegate        = self
        levelsCollectionView.delegate       = self
        birdsCollectionView.dataSource      = self
        levelsCollectionView.dataSource     = self
    }
    func setupDefaultSelectedCells(){
        
        let currentBird = Settings.shared.currentBird
        let currentLevel = Settings.shared.currentLevel
        
        selectedBirdIndexPath = IndexPath(item: currentBird.birdNumber - 1, section: 0)
        selectedLevelIndexPath = IndexPath(item: currentLevel.levelNumber - 1, section: 0)
        
        if self.selectedBirdIndexPath != nil{
            birdsCollectionView.delegate?.collectionView?(birdsCollectionView, didSelectItemAt: selectedBirdIndexPath!)
        }
        if self.selectedLevelIndexPath != nil{
            levelsCollectionView.delegate?.collectionView?(levelsCollectionView, didSelectItemAt: selectedLevelIndexPath!)
            
        }
        
    }
    func setupSceneBeforeReturning(){
        if let selectedLevelIndexPath = selectedLevelIndexPath, let selectedLevel = levels?[selectedLevelIndexPath.item], let selectedBirdIndexPath = selectedBirdIndexPath, let selectedBird = birds?[selectedBirdIndexPath.item] {
            if !selectedLevel.levelIsUnlocked{
                NotificationCenter.default.post(name: .setupCurrentLevelAndBird, object: nil)
            }else{
                if selectedBird.birdIsUnlocked{
                    return
                }else{
                    NotificationCenter.default.post(name: .setupCurrentBird, object: nil)
                }
            }
        }
    }
    
    //MARK: - Animation methods
    //
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.backButtonConstraint.constant = -self.backButton.frame.width - 8
            self.previewButtonConstraint.constant = -self.previewButton.frame.width - 8
            self.collectionViewsContainerView.alpha = 0.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func unhideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.backButtonConstraint.constant = 8
            self.previewButtonConstraint.constant = 8
            self.collectionViewsContainerView.alpha = 1.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func togglePreviewUI(){
        if isUIHiddenForPreview{
            unhideUIForPreview()
        }else{
            hideUIForPreview()
        }
    }
    
    func hideUIForPreview(){
        isUIHiddenForPreview = true
        UIView.animate(withDuration: 0.25) {
            self.backButtonConstraint.constant = -self.backButton.frame.width - 8
            self.collectionViewsContainerView.alpha = 0.0

            self.viewUI.layoutIfNeeded()
        }
    }
    
    func unhideUIForPreview(){
        isUIHiddenForPreview = false
        UIView.animate(withDuration: 0.25) {
            self.backButtonConstraint.constant = 8
            self.collectionViewsContainerView.alpha = 1.0

            self.viewUI.layoutIfNeeded()
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func backAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        
        setupSceneBeforeReturning()
        hideUI {
            self.dismiss(animated: true, completion: {
                self.mainMenuViewController.viewDidAppear(true)
            })
        }
    }
    @IBAction func previewAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        
        togglePreviewUI()
    }
    

}

// END END END END END END END END END END END END END END END END END END END END

//MARK: - Extensions
//
extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == birdsCollectionView, self.birds != nil{
            return self.birds!.count
        }else if collectionView == levelsCollectionView, self.levels != nil{
            return self.levels!.count
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == birdsCollectionView, let birdCell = collectionView.dequeueReusableCell(withReuseIdentifier: birdCellReuseIdentifier, for: indexPath) as? ShopCollectionViewCell, birds != nil {
            birdCell.displayContent(bird: birds![indexPath.row])
            return birdCell
        }else{
            let levelCell = collectionView.dequeueReusableCell(withReuseIdentifier: levelCellReuseIdentifier, for: indexPath) as! ShopCollectionViewCell
            if self.levels != nil{
                levelCell.displayContent(level: levels![indexPath.row])
            }
            return levelCell
        }
        
        
    }
    
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewHeight = collectionView.frame.height
        
        if collectionView == birdsCollectionView{
            return CGSize(width: collectionViewHeight * 0.75, height: collectionViewHeight)
        }else{
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let collectionViewHeight = collectionView.frame.height
        return collectionViewHeight * 0.1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let collectionViewHeight = collectionView.frame.height
        
        let unlockedStatusBirdButtonWidth = collectionViewHeight * 0.75 * 0.25
        let unlockedStatusLevelButtonWidth = collectionViewHeight * 0.2
        
        if collectionView == birdsCollectionView{
            return unlockedStatusBirdButtonWidth
        }else{
            return unlockedStatusLevelButtonWidth
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let collectionViewHeight = collectionView.frame.height
        
        let unlockedStatusBirdButtonWidth = collectionViewHeight * 0.75 * 0.25
        let unlockedStatusLevelButtonWidth = collectionViewHeight * 0.2
        
        if collectionView == birdsCollectionView {
            return UIEdgeInsets(top: 0, left: unlockedStatusBirdButtonWidth * 0.5, bottom: 0, right: unlockedStatusBirdButtonWidth)
        }else{
            return UIEdgeInsets(top: 0, left: unlockedStatusLevelButtonWidth * 0.5, bottom: 0, right: unlockedStatusLevelButtonWidth)
        }
        
    }
    
}

extension ShopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("didSelectItemAtIndex called")
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ShopCollectionViewCell{
            selectedCell.selectCell()
        }
        
        if collectionView == birdsCollectionView{
            if isFirstSelectedBirdIndexPathSetCall{
                isFirstSelectedBirdIndexPathSetCall = false
                return
            }else{
                selectedBirdIndexPath = indexPath
                //update scene & Settings(Optionally)
                if let selectedBird = birds?[selectedBirdIndexPath!.item] {
                    if selectedBird.birdIsUnlocked{
                        // update Settings
                        Settings.shared.currentBird = selectedBird
                        Settings.shared.save()
                    }
                    NotificationCenter.default.post(name: .setupBird, object: selectedBird)
                }
                
            }
        }else{
            if isFirstSelectedLevelIndexPathSetCall {
                isFirstSelectedLevelIndexPathSetCall = false
                return
            }else{
                selectedLevelIndexPath = indexPath
                //update scene & Settings(Optionally)
                if let selectedLevel = levels?[selectedLevelIndexPath!.item] {
                    if selectedLevel.levelIsUnlocked{
                        Settings.shared.currentLevel = selectedLevel
                        Settings.shared.save()
                    }
                    if let selectedBird = birds?[selectedBirdIndexPath!.item] {
                        let levelAndBirdDictionary: [String : Any] = ["level" : selectedLevel,
                                                                      "bird" : selectedBird]
                        NotificationCenter.default.post(name: .setupLevelAndBird, object: levelAndBirdDictionary)
                    }
                }
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAtIndex called")
        if let deselectedCell = collectionView.cellForItem(at: indexPath) as? ShopCollectionViewCell{
            deselectedCell.deselectCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("didHighlightItemAtIndex called")
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        print("didUnhighlightItemAtIndex called")
    }
    
}
