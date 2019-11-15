//
//  Enumerations.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/12/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import Foundation
import UIKit

enum PhysicsCategory: UInt32 {
    case None   = 0
    case Edge   = 1     //0b1
    case Human  = 2     //0b10
    case Bullet = 4     //0b100
}
