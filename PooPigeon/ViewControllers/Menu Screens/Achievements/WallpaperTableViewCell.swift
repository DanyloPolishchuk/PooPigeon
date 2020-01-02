//
//  WallpaperTableViewCell.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 12/8/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit

class WallpaperTableViewCell: UITableViewCell {
    
    var wallpaper: Wallpaper?
    weak var wallpaperActionsDelegate: WallpaperActionsProtocol?
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("WallpaperTableViewCell awakeFromNib called")
        
        shareButton.setImage(UIImage(named: "shareButtonPressed"), for: .highlighted)
        unlockButton.setBackgroundImage(UIImage(named: "bigButtonImagePressed"), for: .highlighted)
    }
    
    func displayContent(wallpaper: Wallpaper){
        self.wallpaper = wallpaper

        wallpaperImageView.image = UIImage(named: wallpaper.wallpaperImageName)
        shareButton.isHidden = !wallpaper.isWallpaperUnlocked
        unlockButton.isHidden = wallpaper.isWallpaperUnlocked
    }
    
    @IBAction func shareAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        if let image = wallpaperImageView.image{
            wallpaperActionsDelegate?.shareImage(image: image)
        }
    }
    @IBAction func unlockAction(_ sender: Any) {
        NotificationCenter.default.post(name: .buttonPressed, object: nil)
        if let wallpaper = self.wallpaper{
            wallpaperActionsDelegate?.showRewardedAdToUnlockWallpaper(wallpaper: wallpaper)
        }
        
    }
    
}
