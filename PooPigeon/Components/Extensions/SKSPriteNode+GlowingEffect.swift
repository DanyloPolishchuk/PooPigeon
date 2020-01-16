//
//  SKSPriteNode+GlowingEffect.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 1/16/20.
//  Copyright © 2020 Polishchuk company. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }
    
}
