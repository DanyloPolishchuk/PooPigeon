//
//  AchievementsViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/8/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Network
import Reachability
import Photos

class AchievementsViewController: BaseBannerAdViewController {

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: - Properties
    //
    
    @available(iOS 12.0, *)
    lazy var pathMonitor: NWPathMonitor? = {return nil}()
    let reachabilityHandler = try? Reachability()
    
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
        setupNetworkAvaliabilityChecker()
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
    func setupNetworkAvaliabilityChecker(){
        print("setupNetworkAvaliabilityChecker called")
        // IOS 12+
        if #available(iOS 12, *) {
            print("NWPathMonitor setupped")
            pathMonitor = NWPathMonitor()
            pathMonitor?.pathUpdateHandler = { path in
                // closure gets called every time the connection status changes.
                if path.status == .satisfied {
                    print("NWPathMonitor path status changed to .satisfied")
                    if self.rewardedAd?.responseInfo == nil {
                        print("rewardedAd?.responseInfo == nil; ad reload called")
                        self.rewardedAd = self.createAndLoadRewardedAd()
                    }
                }
            }
            let queue = DispatchQueue(label: "Monitor")
            pathMonitor?.start(queue: queue)
        }else { // IOS <12
            print("Reachability setupped")
            reachabilityHandler?.whenReachable = { reachability in
                print("Reachability status changed to reachable")
                if self.rewardedAd?.responseInfo == nil {
                    print("rewardedAd?.responseInfo == nil; ad reload called")
                    self.rewardedAd = self.createAndLoadRewardedAd()
                }
            }
            do{
                try reachabilityHandler?.startNotifier()
            } catch {
                print("unable to start notifier")
            }
        }
        
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
        let rewardedAdUnitID = rewardedAdAdUnitID == nil ? "ca-app-pub-3940256099942544/1712485313" : rewardedAdAdUnitID!
        let rewardedAd = GADRewardedAd(adUnitID: rewardedAdUnitID)
        rewardedAd.load(GADRequest()) { (error) in
            if let error = error {
                print("RewardedAd Loading failed: \(error)")
            } else {
                NotificationCenter.default.post(name: .rewardedAdDidLoadSuccessfully, object: nil)
                print("RewardedAd Loading Succeeded")
            }
        }
        return rewardedAd
    }
    func showRewardedAd(){
        if self.rewardedAd?.isReady == true {
            manageMusicBeforeShowingAd()
            rewardedAd?.present(fromRootViewController: self, delegate: self)
        }else{
            showAdCantLoadAlert()
        }
    }
    func manageMusicBeforeShowingAd(){
        if Settings.shared.isMusicEnabled {
            NotificationCenter.default.post(name: .turnMusicOff, object: nil)
        }
    }
    func manageMusicAfterShowingAd(){
        if Settings.shared.isMusicEnabled {
            NotificationCenter.default.post(name: .turnMusicOn, object: nil)
        }
    }
    func userDidUnlock(wallpaper: Wallpaper) {
        Settings.shared.unlockWallpaperAtIndex(wallpaper.wallpaperNumber - 1)
        self.wallpapers[wallpaper.wallpaperNumber - 1].isWallpaperUnlocked = true
        setupDataSource()
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        //TODO: may be add cell selection (to scroll to unlocked cell) if reloadSections Doesn't handle it
    }
    
    //MARK: - Transition methods
    //
    func showAdCantLoadAlert(){
        if let adAlertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "adsCantLoadAlertScreen") as? AdsCantLoadAlertViewController {
            adAlertVC.achievementsViewController = self
            hideBannerView()
            self.present(adAlertVC, animated: true)
        }
    }
    func showImageLibraryCantBeAccessedAlert(){
        if let imageAccessAlertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageLibraryAccessScreenIdentifier") as? ImageLibraryAccessAlertViewController {
            imageAccessAlertVC.achievementsViewController = self
            hideBannerView()
            self.present(imageAccessAlertVC, animated: true)
        }
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
    
    func shareImage(image: UIImage) {
        
        let authorizationStatus =  PHPhotoLibrary.authorizationStatus()
        print("authorizationStatus = \(authorizationStatus.rawValue)")
        
        if authorizationStatus == .notDetermined{
            PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
                if authorizationStatus == .authorized {
                    let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true)
                }
            }
            return
        }else if authorizationStatus == .denied {
            showImageLibraryCantBeAccessedAlert()
            return
        }
        
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
        manageMusicAfterShowingAd()
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present due to error: \(error)")
        manageMusicAfterShowingAd()
    }
    
}
