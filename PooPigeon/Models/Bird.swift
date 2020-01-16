//
//  Bird.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

struct Bird: Codable {
    
    let birdNumber: Int
//    let birdLevelNumber: Int
    let birdName: String
//    let birdSceneFileName: String
    
    let birdSpawnPosition: CGPoint
    let birdTexture: String
    let birdAnimationTextureNames: [String]
    let birdShootTextureName: String
    let birdSoundFileName: String
    
}
