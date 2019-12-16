//
//  Enemy.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/29/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

struct Enemy: Codable {
    let texture: String
    let physicsBodyTexture: String
    let animationTextureNames: [String]
}
