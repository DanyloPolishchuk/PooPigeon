//
//  AppDelegate.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/12/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - Properties
    //
    var window: UIWindow?
    
    // time challenge properties
    let nanoSecsToSecsMultiplier = 0.000000001 // 1 second == 1 billion nanoseconds
    var startTime: DispatchTime?
    var endTime: DispatchTime?
    

    //MARK: - Lifecycle methods
    //
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        increaseGameLaunchesCount()
        updateGameLaunchDaysCount()
        setupLastLaunchTime()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        endTime = DispatchTime.now()
        updateTimeSpentInGame()
        
        NotificationCenter.default.post(name: .pauseOnResignActive, object: nil)
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        startTime = DispatchTime.now()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - Challenge tracking methods
    //
    func updateTimeSpentInGame(){
        if let startTime = self.startTime, let endTime = self.endTime{
            self.startTime  = nil
            self.endTime    = nil
            
            let nanoTimeDifference = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
            let timeInterval = Double(nanoTimeDifference)
            let timeIntervalInSeconds = UInt(timeInterval * nanoSecsToSecsMultiplier)
            Settings.shared.timeInSecsSpentInGame += timeIntervalInSeconds
            Settings.shared.save()
        }
    }
    
    func increaseGameLaunchesCount(){
        Settings.shared.timesGameWasLaunched += 1
        Settings.shared.save()
    }
    
    func setupLastLaunchTime(){        
        Settings.shared.lastLaunchTimeDate = Date()
        Settings.shared.save()
    }
    
    func updateGameLaunchDaysCount() {
        
        if Settings.shared.isFirstLaunch {
            Settings.shared.amountOfDaysGameWasLaunched += 1
            Settings.shared.isFirstLaunch = false
            Settings.shared.save()
            return
        }
        
        let lastLaunchDate = Settings.shared.lastLaunchTimeDate
        let currentLaunchDate = Date()
        
        let dateDifferenceComponents = Calendar.current.dateComponents([.day], from: lastLaunchDate, to: currentLaunchDate)
        let daysBetweenLaunches = dateDifferenceComponents.day
        
        if let days = daysBetweenLaunches, days >= 1 {
            Settings.shared.amountOfDaysGameWasLaunched += 1
            Settings.shared.save()
        }
        
    }

}

