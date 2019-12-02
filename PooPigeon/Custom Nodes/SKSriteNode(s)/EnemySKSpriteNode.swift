//
//  EnemySKSpriteNode.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/30/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class EnemySKSpriteNode: SKSpriteNode {
    
    let destinationX: CGFloat
    let walkAnimationActionKey = "walkAnimationActionKey"
    let walkActionKey = "walkActionKey"
    let runActionKey = "runActionKey"
    let walkAnimationSpeed: TimeInterval = 1/3
    let runAnimationSpped: TimeInterval = 1/6
    let animationTextures: [SKTexture]
    
    init(_ enemy: Enemy,_ destinationX: CGFloat) {
        
        self.destinationX = destinationX
        self.animationTextures = enemy.animationTextureNames.map{ SKTexture(imageNamed: $0) }
        
        let enemyTexture = SKTexture(imageNamed: enemy.texture)
        let enemyPhysicsBodyTexture = SKTexture(imageNamed: enemy.physicsBodyTexture)
        
        super.init(texture: enemyTexture, color: .clear, size: enemyTexture.size())
        
        self.name = "enemyNode"
        
        self.physicsBody = SKPhysicsBody(texture: enemyPhysicsBodyTexture, size: enemyPhysicsBodyTexture.size())
        self.physicsBody?.categoryBitMask = PhysicsCategory.Human.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Bullet.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Bullet.rawValue
        self.physicsBody?.allowsRotation = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// starts walk texture animation & moveToX action
    func walk(){
        let walkAnimationAction = SKAction.animate(with: animationTextures, timePerFrame: walkAnimationSpeed)
        let walkInfiniteAnimationAction = SKAction.repeatForever(walkAnimationAction)
        let walkMoveAction = SKAction.moveTo(x: destinationX, duration: 4.0)
        let walkMoveSequnce = SKAction.sequence([
            walkMoveAction,
            SKAction.removeFromParent(),
            SKAction.run {
                print("enemyNode is removed after walk")
            }
            ])
        self.run(walkInfiniteAnimationAction, withKey: walkAnimationActionKey)
        self.run(walkMoveSequnce, withKey: walkActionKey)
    }
    /// cancels previous action, starts run texture animation & moveToX action & removes node
    func run(){
        self.removeAction(forKey: walkActionKey)
        self.removeAction(forKey: walkAnimationActionKey)
        
        let runAnimationAction = SKAction.animate(with: animationTextures, timePerFrame: runAnimationSpped)
        let runInfiniteAnimationAction = SKAction.repeatForever(runAnimationAction)
        
        let runMoveAction = SKAction.moveTo(x: destinationX, duration: 2.0)
        let runMoveSequence = SKAction.sequence([
            runMoveAction,
            SKAction.removeFromParent(),
            SKAction.run {
                print("enemyNode is removed after run")
            }
            ])
        self.run(runInfiniteAnimationAction, withKey: runActionKey)
        self.run(runMoveSequence)
    }
    
}
