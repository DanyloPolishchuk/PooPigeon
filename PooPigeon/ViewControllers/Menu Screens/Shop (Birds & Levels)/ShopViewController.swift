//
//  ShopViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/13/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import StoreKit

class ShopViewController: BaseBannerAdViewController {
    
    //MARK: - Properties
    //
    var heroes: [Hero]?
    var levels: [Level]?
    
    //IAP
    var products = [SKProduct]()
    
    var isFirstSelectedBirdIndexPathSetCall = true
    var isFirstSelectedLevelIndexPathSetCall = true
    var selectedHeroIndexPath: IndexPath?
    var selectedLevelIndexPath: IndexPath?
    
    let birdCellReuseIdentifier = "birdCellReuseIdentifier"
    let levelCellReuseIdentifier = "levelCellReuseIdentifier"
    let unlockAllBirdsCellReuseIdentifier = "unlockAllBirdsCellReuseIdentifier"
    let unlockAllLevelsCellReuseIdentifier = "unlockAllLevelsCellReuseIdentifier"
    
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
        
        setupIAP()
        setupTopButtons()
        setupDefaultConstraints()
        updateDataSources()
        setupDataSources()
        setupCollectionViews()
        setupDefaultSelectedCells()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unhideUI {}
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
        self.heroes = Settings.shared.getHeroes()
        self.levels = Settings.shared.getLevels()
    }
    func setupCollectionViews(){
        birdsCollectionView.delegate        = self
        levelsCollectionView.delegate       = self
        birdsCollectionView.dataSource      = self
        levelsCollectionView.dataSource     = self
    }
    func setupDefaultSelectedCells(){
        
        let currentHero = Settings.shared.currentHero
        let currentLevel = Settings.shared.currentLevel
        
        selectedHeroIndexPath = IndexPath(item: currentHero.number - 1, section: 0)
        selectedLevelIndexPath = IndexPath(item: currentLevel.levelNumber - 1, section: 0)
        
        self.birdsCollectionView.performBatchUpdates({
            self.birdsCollectionView.reloadData()
        }) { (isFinished) in
            if isFinished {
                if self.selectedHeroIndexPath != nil{
                    self.birdsCollectionView.delegate?.collectionView?(self.birdsCollectionView, didSelectItemAt: self.selectedHeroIndexPath!)
                }
            }
        }
        
        self.levelsCollectionView.performBatchUpdates({
            self.levelsCollectionView.reloadData()
        }) { (isFinished) in
            if isFinished {
                if self.selectedLevelIndexPath != nil{
                    self.levelsCollectionView.delegate?.collectionView?(self.levelsCollectionView, didSelectItemAt: self.selectedLevelIndexPath!)
                    
                }
            }
        }
        
    }
    func setupSceneBeforeReturning(){
        if let selectedLevelIndexPath = selectedLevelIndexPath, let selectedLevel = levels?[selectedLevelIndexPath.item], let selectedHeroIndexPath = selectedHeroIndexPath, let selectedHero = heroes?[selectedHeroIndexPath.item] {
            if !selectedLevel.levelIsUnlocked{
                NotificationCenter.default.post(name: .setupCurrentLevelAndHero, object: nil)
            }else{
                if selectedHero.isUnlocked{
                    return
                }else{
                    NotificationCenter.default.post(name: .setupCurrentHero, object: nil)
                }
            }
        }
    }
    
    //MARK: - IAP methods
    //
    func setupIAP(){
        NotificationCenter.default.addObserver(self, selector: #selector(allBirdsUnlockedHandler), name: .unlockAllHeroesPurchasedSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(allLevelsUnlockedHandler), name: .unlockAllLevelsPurchasedSuccessfully, object: nil)
        //        SpinWheelSplash.screen.display()
        IAPProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
            }
            //            SpinWheelSplash.screen.dismiss()
        }
    }
    
    func buyUnlockAllBirds(){
        for product in products {
            if product.productIdentifier == IAPProducts.unlockAllHeroesIdentifier {
                IAPProducts.store.buyProduct(product)
                break
            }
        }
    }
    
    @objc func allBirdsUnlockedHandler(){
        birdsCollectionView.reloadData()
        setupDefaultSelectedCells()
    }
    
    func buyUnlockAllLevels(){
        for product in products {
            if product.productIdentifier == IAPProducts.unlockAllLevelsIdentifier {
                IAPProducts.store.buyProduct(product)
                break
            }
        }
    }
    
    @objc func allLevelsUnlockedHandler(){
        levelsCollectionView.reloadData()
        setupDefaultSelectedCells()
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
        
        let canMakePayments = IAPHelper.canMakePayments()
        
        if collectionView == birdsCollectionView, self.heroes != nil{
            return self.heroes!.count + (canMakePayments && !Settings.shared.isEveryHeroUnlocked ? 1 : 0)
        }else if collectionView == levelsCollectionView, self.levels != nil{
            return self.levels!.count + (canMakePayments && !Settings.shared.isEveryLevelUnlocked ? 1 : 0)
        }else{
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == birdsCollectionView{
            
            if let selectedHeroIndexPath = self.selectedHeroIndexPath{
                if selectedHeroIndexPath == indexPath {
                    (cell as? ShopCollectionViewCell)?.selectCell()
                }else{
                    (cell as? ShopCollectionViewCell)?.deselectCell()
                }
            }
            
        }else{
            
            if let selectedLevelIndexPath = self.selectedLevelIndexPath{
                if selectedLevelIndexPath == indexPath {
                    (cell as? ShopCollectionViewCell)?.selectCell()
                }else{
                    (cell as? ShopCollectionViewCell)?.deselectCell()
                }
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if collectionView == birdsCollectionView {
            if indexPath.row == heroes?.count { // unlockAllHeroes cell
                let unlockAllCell = collectionView.dequeueReusableCell(withReuseIdentifier: unlockAllBirdsCellReuseIdentifier, for: indexPath) as! UnlockAllCollectionViewCell
                unlockAllCell.type = .UnlockAllBirds
                unlockAllCell.shopPurchasesDelegate = self
                return unlockAllCell
            }else{ // regular bird cell
                let birdCell = collectionView.dequeueReusableCell(withReuseIdentifier: birdCellReuseIdentifier, for: indexPath) as! ShopCollectionViewCell
                birdCell.displayContent(hero: heroes![indexPath.row])
                
                return birdCell
            }
        }else{
            if indexPath.row == levels?.count { // unlockAllLevels cell
                let unlockAllCell = collectionView.dequeueReusableCell(withReuseIdentifier: unlockAllLevelsCellReuseIdentifier, for: indexPath) as! UnlockAllCollectionViewCell
                unlockAllCell.type = .UnlockAllLevels
                unlockAllCell.shopPurchasesDelegate = self
                return unlockAllCell
            }else{ // regular level cell
                let levelCell = collectionView.dequeueReusableCell(withReuseIdentifier: levelCellReuseIdentifier, for: indexPath) as! ShopCollectionViewCell
                levelCell.displayContent(level: levels![indexPath.row])
                
                return levelCell
            }
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
            if indexPath.row == heroes?.count{ // unlockAllHeroes cell is selected
                return
            }
            if isFirstSelectedBirdIndexPathSetCall{
                isFirstSelectedBirdIndexPathSetCall = false
                return
            }else{
                selectedHeroIndexPath = indexPath
                //update scene & Settings(Optionally)
                if let selectedHero = heroes?[selectedHeroIndexPath!.item] {
                    if selectedHero.isUnlocked{
                        // update Settings
                        Settings.shared.currentHero = selectedHero
                        Settings.shared.save()
                    }
                    NotificationCenter.default.post(name: .setupHero, object: selectedHero)
                }
                
            }
        }else{
            if indexPath.row == levels?.count { // unlockAllLevels cell is selected
                return
            }
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
                    if let selectedHero = heroes?[selectedHeroIndexPath!.item] {
                        let levelAndBirdDictionary: [String : Any] = ["level" : selectedLevel,
                                                                      "hero" : selectedHero]
                        NotificationCenter.default.post(name: .setupLevelAndHero, object: levelAndBirdDictionary)
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

extension ShopViewController: ShopPurchasesProtocol {
    func unlockAllBirds() {
        buyUnlockAllBirds()
    }
    
    func unlockAllLevels() {
        buyUnlockAllLevels()
    }
    
}
