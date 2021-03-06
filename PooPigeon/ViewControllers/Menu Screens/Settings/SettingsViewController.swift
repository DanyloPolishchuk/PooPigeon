//
//  SettingsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/5/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: BaseBannerAdViewController {
    
    //MARK: - Properties
    //
    let cellReuseIdentifier = "settingCellReuseIdentifier"
    weak var mainMenuViewConroller: MainMenuViewController!
    let constantCellsArr: [SettingButtonType] = [
        .Sound,
        .Music,
        .Language,
        .Credits,
        .ContantInfo,
        .RestorePurchases,
        .UIhand
    ]
    var temporaryCellsArr = [SettingButtonType]()
    var finalCellsArr: [SettingButtonType]?
    //IAP
    var products = [SKProduct]()
    
    //MARK: - Outlets
    //
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var leftTopButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var rightTopButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewContainerView: UIView!
    @IBOutlet weak var settingsLabel: LocalizedLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewUI: UIView!
    

    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIAP()
        setupTopButtonsImages()
        setupTopButtons()
        setupNotifications()
        setupDefaultConstraints()
        setupCellsArray()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unhideUI {}
    }
    
    //MARK: - Setup methods
    //
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupTopButtons), name: .changeTopButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .updateLanguage, object: nil)
    }
    func setupTopButtonsImages(){
        rightTopButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
        leftTopButton.setImage(UIImage(named: "backButtonPressed"), for: .highlighted)
    }
    @objc func setupTopButtons(){
        (Settings.shared.isLeftHandedUI ? rightTopButton : leftTopButton)?.isHidden = true
        (Settings.shared.isLeftHandedUI ? leftTopButton : rightTopButton)?.isHidden = false
    }
    @objc func updateLanguage(){
        settingsLabel.update()
        collectionView.reloadData()
    }
    func setupDefaultConstraints(){
        leftTopButtonConstraint.constant = -leftTopButton.frame.width - 8
        rightTopButtonConstraint.constant = -rightTopButton.frame.width - 8
        collectionViewContainerView.alpha = 0.0
    }
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func setupCellsArray(){
        
        temporaryCellsArr = [SettingButtonType]()
        
        let temporarySettings = Settings.shared.getTemporarySettings()
        if temporarySettings[0] == false{
            temporaryCellsArr.append(.Like)
        }
        if temporarySettings[1] == false{
            temporaryCellsArr.append(.Share)
        }
        // "Review" is probably a part of "Like" API, so it's temporarily removed. Add if while implementing "Like" turns out that it's not a part of API
//        if temporarySettings[2] == false{
//            temporaryCellsArr.append(.Review)
//        }
        if temporarySettings[3] == false && IAPHelper.canMakePayments() {
            temporaryCellsArr.append(.RemoveAdds)
        }
        
        finalCellsArr = constantCellsArr + temporaryCellsArr
    }
    
    //MARK: - IAP methods
    //
    func setupIAP(){
        NotificationCenter.default.addObserver(self, selector: #selector(adsRemovedHandler), name: .removeAdsPurchasedSuccessfully, object: nil)
//        SpinWheelSplash.screen.display()
        IAPProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
            }
//            SpinWheelSplash.screen.dismiss()
        }
    }
    
    func buyRemoveAds(){
        for product in products {
            if product.productIdentifier == IAPProducts.removeAdsIdentifier {
                IAPProducts.store.buyProduct(product)
                break
            }
        }
    }
    
    @objc func adsRemovedHandler(){
        hideBannerView()
        setupCellsArray()
        collectionView.reloadData()
    }
    
    //MARK: - Animation methods
    //
    // add method that'd swap top buttons
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftTopButtonConstraint.constant = -self.leftTopButton.frame.width - 8
            self.rightTopButtonConstraint.constant = -self.rightTopButton.frame.width - 8
            self.collectionViewContainerView.alpha = 0.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func unhideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftTopButtonConstraint.constant = 8
            self.rightTopButtonConstraint.constant = 8
            self.collectionViewContainerView.alpha = 1.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    //MARK: - Actions
    //
    @IBAction func backAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        
        hideUI {
            self.dismiss(animated: true, completion: {
                self.mainMenuViewConroller.viewDidAppear(true)
            })
        }
    }
    
}
//MARK: - Extensions
//
extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let finalCellsArr = finalCellsArr{
            return finalCellsArr.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SettingsCollectionViewCell
        if let finalCellsArr = finalCellsArr {
            cell.settingsScreenPresentationDelegate = self
            cell.displayContent(buttonType: finalCellsArr[indexPath.row])
        }
        return cell
    }
    
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width * 0.33
        return CGSize(width: collectionViewWidth, height: collectionViewWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}

extension SettingsViewController: SettingsScreensPresentationProtocol{
    
    func likeApplication() {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "AppID") as? String, let reviewURL = URL(string: "https://itunes.apple.com/app/id\(appID)?action=write-review") else{return}
        UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
    }
    
    func shareApplication() {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "AppID") as? String, let shareURL = URL(string: "http://itunes.apple.com/app/id\(appID)") else {return}
        let objectsToShare = [shareURL]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    func showCredits() {
        if let creditsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creditsScreenStoryboardID") as? CreditsViewController {
            creditsVC.settingsViewController = self
            hideBannerView()
            self.present(creditsVC, animated: true)
        }
    }
    
    func showContactInfo() {
        if let contactUsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactUsScreenStoryboardIdentifier") as? ContactUsViewController {
            contactUsVC.settingsViewController = self
            hideBannerView()
            self.present(contactUsVC, animated: true)
        }
    }
    
    func restorePurchases() {
        IAPProducts.store.restorePurchases()
    }
    
    func removeAds() {
        buyRemoveAds()
    }
    
    func showLanguageSelection() {
        if let languageSelectionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "languageSelectionScreenIdentifier") as? LanguageSelectionViewController {
            languageSelectionVC.settingsViewController = self
            hideBannerView()
            self.present(languageSelectionVC, animated: true)
        }
    }
    
}
