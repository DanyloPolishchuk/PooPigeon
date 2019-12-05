//
//  BirdSKSpriteNode.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/30/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import UIKit
import SpriteKit

class BirdSKSpriteNode: SKSpriteNode {
    
    let idleAnimationKey = "idleAnimationKey"
    let birdTexture: String
    let shootTexture: SKTexture
    let idleAnimationTextures: [SKTexture]
    let birdSoundFileName: String
    
    init(_ bird: Bird) {
        
        let birdTexture = SKTexture(imageNamed: bird.birdTexture)
        self.birdTexture = bird.birdTexture
        self.idleAnimationTextures = bird.birdAnimationTextureNames.map{ SKTexture(imageNamed: $0) }
        self.shootTexture = SKTexture(imageNamed: bird.birdShootTextureName)
        self.birdSoundFileName = bird.birdSoundFileName
        
        super.init(texture: birdTexture, color: .clear, size: birdTexture.size())
        
        self.name = "birdNode"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startIdleAnimation(){
        let idleAnimationAction = SKAction.animate(with: idleAnimationTextures, timePerFrame: 0.375)
        let infiniteIdleAnimationAction = SKAction.repeatForever(idleAnimationAction)
        self.run(infiniteIdleAnimationAction, withKey: idleAnimationKey)
    }
    
    func shoot(){
        
        let shootAction = SKAction.run {
            self.texture = self.shootTexture
            NotificationCenter.default.post(name: .sfxSoundPlay, object: nil)
        }
        let shootActionSequence = SKAction.sequence([
            shootAction,
            SKAction.wait(forDuration: 0.5)
            ])
        removeAction(forKey: idleAnimationKey)
        self.run(shootActionSequence){
            self.startIdleAnimation()
        }
    }
    
}
