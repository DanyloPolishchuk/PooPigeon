//
//  AchievementsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/8/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AchievementsViewController: BaseBannerAdViewController {

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: - Properties
    //
    var rewardedAd: GADRewardedAd?
    var wallpaperToUnlock: Wallpaper?
    
    weak var mainMenuViewCotnroller: MainMenuViewController!
    let headerViewCellReuseIdentifier = "headerViewCellReuseIdentifier"
    let progressCellReuseIdentifier = "progressCellReuseIdentifier"
    let wallpaperCellReuseIdentifier = "wallpaperCellReuseIdentifier"
    
    let challengesProgress: [ChallengeType] = [
        .BestScore,
        .TotalScore,
        .TotalLoseTimes,
        .TotalTimeSpentInGame,
        .TotalTimesGameWasLaunched,
        .TotalDaysGameWasLaunched
        // other challenge types are just one action (lik "Like", "Share" etc. or not progressable (specific date)
    ]
    var wallpapers = Settings.shared.getWallpapers()
    var finalArr: [[Any]]?
    
    //MARK: - Outlets
    //
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var leftTopButton: UIButton!
    @IBOutlet weak var rightTopButton: UIButton!
    @IBOutlet weak var tableViewContainerView: UIView!
    @IBOutlet weak var screnNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    // constraints
    @IBOutlet weak var leftTopButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTopButtonConstraint: NSLayoutConstraint!
    
    //MARK: - Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopButtons()
        setupDefaultConstraints()
        setupDataSource()
        setupDelegates()
        setupRewardedAd()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unhideUI {}
    }
    
    //MARK: - Setup methods
    //
    func setupTopButtons(){
        (Settings.shared.isLeftHandedUI ? rightTopButton : leftTopButton)?.isHidden = true
        (Settings.shared.isLeftHandedUI ? leftTopButton : rightTopButton)?.isHidden = false
    }
    func setupDefaultConstraints(){
        self.leftTopButtonConstraint.constant = -self.leftTopButton.frame.width - 8
        self.rightTopButtonConstraint.constant = -self.rightTopButton.frame.width - 8
        self.tableViewContainerView.alpha = 0.0
    }
    func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    func setupDataSource(){
        finalArr = [
        challengesProgress,
        wallpapers
        ]
        
    }
    func setupRewardedAd(){
        self.rewardedAd = createAndLoadRewardedAd()
    }
    
    //MARK: - Animation methods
    //
    func hideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftTopButtonConstraint.constant = -self.leftTopButton.frame.width - 8
            self.rightTopButtonConstraint.constant = -self.rightTopButton.frame.width - 8
            self.tableViewContainerView.alpha = 0.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    func unhideUI(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.25, animations: {
            self.leftTopButtonConstraint.constant = 8
            self.rightTopButtonConstraint.constant = 8
            self.tableViewContainerView.alpha = 1.0
            
            self.viewUI.layoutIfNeeded()
        }) { (animationsFinishedBeforeCompletion) in
            completion()
        }
    }
    
    //MARK: - Google Ads methods
    //
    func createAndLoadRewardedAd() -> GADRewardedAd {
        let rewardedAdAdUnitID = Bundle.main.object(forInfoDictionaryKey: "GADRewardedAdUnitID") as? String
        let rewardedAd = GADRewardedAd(adUnitID: rewardedAdAdUnitID == nil ? "ca-app-pub-3940256099942544/1712485313" : rewardedAdAdUnitID! )
        rewardedAd.load(GADRequest()) { (error) in
            if let error = error {
                print("RewardedAd Loading failed: \(error)")
            } else {
                print("RewardedAd Loading Succeeded")
            }
        }
        return rewardedAd
    }
    func showRewardedAd(){
        if self.rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: self, delegate: self)
        }else{
            //TODO: add some kind of "ad is being loaded" alert
            print("rewardedAd.is NOT Ready")
        }
    }
    func userDidUnlock(wallpaper: Wallpaper) {
        Settings.shared.unlockWallpaperAtIndex(wallpaper.wallpaperNumber - 1)
        self.wallpapers[wallpaper.wallpaperNumber - 1].isWallpaperUnlocked = true
        setupDataSource()
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        //TODO: may be add cell selection if reloadDoesn't handle it
    }
    
    
    //MARK: - Actions
    //
    @IBAction func backAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        
        hideUI {
            self.dismiss(animated: true, completion: {
                self.mainMenuViewCotnroller.viewDidAppear(true)
            })
        }
    }
    
}
//MARK: - Extensions
//
extension AchievementsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else if indexPath.section == 1 {
            return tableView.frame.width / 2
        }else{
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: headerViewCellReuseIdentifier) as? HeaderTableViewCell {
            if section == 0{ // replace with localized strings
                headerCell.displayContent(headerText: "PROGRESS")
            }else{
                headerCell.displayContent(headerText: "WALLPAPERS")
            }
            return headerCell
        }else{
            return nil
        }
    }
    
}

extension AchievementsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let finalArr = self.finalArr{
            return finalArr.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let finalArr = self.finalArr{
            return finalArr[section].count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // progress
            let cell = tableView.dequeueReusableCell(withIdentifier: progressCellReuseIdentifier, for: indexPath) as! ProgressTableViewCell
            
            if let finalArr = self.finalArr, let challengeType = finalArr[indexPath.section][indexPath.row] as? ChallengeType{
                cell.displayContent(challengeType: challengeType)
            }
            
            return cell
        }else{ // wallpaper
            let cell = tableView.dequeueReusableCell(withIdentifier: wallpaperCellReuseIdentifier, for: indexPath) as! WallpaperTableViewCell
            
            if let finalArr = self.finalArr, let wallpaper = finalArr[indexPath.section][indexPath.row] as? Wallpaper {
                cell.wallpaperActionsDelegate = self
                cell.displayContent(wallpaper: wallpaper)
            }
            
            return cell
        }
    }
    
}

extension AchievementsViewController: WallpaperActionsProtocol {
    
    //TODO: add "Go to app settings to turn on image library access" alert if images lib is inaccesible
    func shareImage(image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true)
    }
    
    func showRewardedAdToUnlockWallpaper(wallpaper: Wallpaper) {
        self.wallpaperToUnlock = wallpaper
        showRewardedAd()
    }
    
}
// GADRewardedAdDelegate
extension AchievementsViewController: GADRewardedAdDelegate {
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        if let wallpaperToUnlock = self.wallpaperToUnlock{
            self.userDidUnlock(wallpaper: wallpaperToUnlock)
        }
    }
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
        self.rewardedAd = createAndLoadRewardedAd()
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present due to error: \(error)")
    }
    
}
