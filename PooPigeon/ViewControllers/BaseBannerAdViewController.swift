//
//  BaseBannerAdViewController.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/28/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BaseBannerAdViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !Settings.shared.isAddsRemovalPurchased { 
            setupGADBannerView()
        }
    }
    
    func setupGADBannerView(){
        guard let bannerViewAdUnitID = Bundle.main.object(forInfoDictionaryKey: "GADBannerViewAdUnitID") as? String else {
            print("Can't get adUnitID string from .plist")
            return
        }
        bannerView.adUnitID = bannerViewAdUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    func hideBannerView(){
        self.bannerView.isHidden = true
    }
    
    func unhideBannerView(){
        if !Settings.shared.isAddsRemovalPurchased {
            self.bannerView.isHidden = false
        }
    }
    
}

extension BaseBannerAdViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("BaseBannerAdViewController \(self.restorationIdentifier) adViewDidReceiveAd")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("BaseBannerAdViewController adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("BaseBannerAdViewController adViewWillPresentScreen")
    }
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("BaseBannerAdViewController adViewWillDismissScreen")
    }
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("BaseBannerAdViewController adViewDidDismissScreen")
    }
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("BaseBannerAdViewController adViewWillLeaveApplication")
    }
}
