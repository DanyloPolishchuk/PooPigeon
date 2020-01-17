//
//  HeroSKSpriteNode.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/30/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class HeroSKSpriteNode: SKSpriteNode {
    
    let idleAnimationActionKey = "idleAnimationActionKey"
    let hitAnimationActionKey = "hitAnimationActionKey"
    let loseAnimationActionKey = "loseAnimationActionKey"
    let animationTime: TimeInterval = 1/2
    let hitAnimationTime: TimeInterval = 1/6
    
    let idleAnimationTextures:  [SKTexture]
    let hitAnimationTextures:   [SKTexture]
    let loseAnimationTextures:  [SKTexture]
    
    init(_ hero: Hero) {
        
        self.idleAnimationTextures = hero.idleTextureNames.map{ SKTexture(imageNamed: $0) }
        self.hitAnimationTextures = hero.hitTextureNames.map{ SKTexture(imageNamed: $0) }
        self.loseAnimationTextures = hero.loseTextureNames.map{ SKTexture(imageNamed: $0) }
        
        let heroTexture = SKTexture(imageNamed: hero.texture)
        let heroPhysicsBodyTexture = SKTexture(imageNamed: hero.physicsBodyTexture)
        
        super.init(texture: heroTexture, color: .clear, size: heroTexture.size())
        
        self.name = "heroNode"
        
        self.physicsBody = SKPhysicsBody(texture: heroPhysicsBodyTexture, size: heroPhysicsBodyTexture.size())
        self.physicsBody?.categoryBitMask = PhysicsCategory.Human.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Egg.rawValue | PhysicsCategory.Poo.rawValue | PhysicsCategory.Bonus.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Egg.rawValue | PhysicsCategory.Poo.rawValue | PhysicsCategory.Bonus.rawValue
        self.physicsBody?.allowsRotation = false
        idle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func idle(){
        let idleAnimationAction = SKAction.animate(with: idleAnimationTextures, timePerFrame: animationTime)
        self.run(SKAction.repeatForever(idleAnimationAction), withKey: idleAnimationActionKey)
    }
    func hit(){
        let hitAnimationAction = SKAction.animate(with: hitAnimationTextures, timePerFrame: hitAnimationTime)
        let idleAnimationAction = SKAction.run {
            self.idle()
        }
        self.run(SKAction.sequence([
            hitAnimationAction,
            idleAnimationAction
            ]), withKey: hitAnimationActionKey)
    }
    func lose(){
        let loseAnimationAction = SKAction.animate(with: loseAnimationTextures, timePerFrame: animationTime)
//        let idleAnimationAction = SKAction.run {
//            self.idle()
//        }
//        self.run(SKAction.sequence([
//            loseAnimationAction,
//            idleAnimationAction
//            ]), withKey: loseAnimationActionKey)
        self.run(SKAction.repeatForever(loseAnimationAction), withKey: loseAnimationActionKey)
    }

}
