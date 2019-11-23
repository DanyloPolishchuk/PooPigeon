//
//  GameScene.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/12/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: BaseSKScene {
    
    // default game project stuff
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    //
    
    private var fg: SKNode!
    
    private var scoreLabel: SKLabelNode!
    private var currentScore = 0
    private var pooSpawnPosition: CGPoint!
    private var birdNode: SKSpriteNode!
    private var birdIsShooting = false
    private var human: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.physicsWorld.contactDelegate = self
        
        self.bg = self.childNode(withName: "bg")
        self.fg = self.childNode(withName: "fg")
        
        self.birdNode = fg.childNode(withName: "bird") as? SKSpriteNode
        self.pooSpawnPosition = birdNode.position
        self.human = fg.childNode(withName: "humanNode") as? SKSpriteNode
        self.scoreLabel = fg.childNode(withName: "scoreLabelNode") as? SKLabelNode
        
        let bodyTexture = SKTexture(imageNamed: "level1ManWalkingBodyTexture")
        human.physicsBody = SKPhysicsBody(texture: bodyTexture, size: bodyTexture.size())
        human.physicsBody?.categoryBitMask = PhysicsCategory.Human.rawValue
        human.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Bullet.rawValue
        human.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Bullet.rawValue
        
        let walkAction = SKAction.moveBy(x: 1598, y: 0, duration: 2.0)
        let humanWalkAction = SKAction.repeatForever(SKAction.sequence([
            walkAction,
            SKAction.run {
                self.human.xScale = -1
            },
            walkAction.reversed(),
            SKAction.run {
                self.human.xScale = 1
            }
            ]))
        human.run(humanWalkAction)
        
        //TODO: increase playable area width by 2x of target width (human node(s) )
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.frame.width / 2,
                                                              y: -self.frame.height / 2 + 256,
                                                              width: self.frame.width,
                                                              height: self.frame.height - 256))
        physicsBody?.categoryBitMask = PhysicsCategory.Edge.rawValue
        
        
    }
    
    //MARK: - Score methods
    //
    func resetScore(){
        print("resetScore called")
        self.currentScore = 0
        setScoreLabelTextTo(text: String(self.currentScore))
    }
    func increaseScore(){
        print("increaseScore called")
        self.currentScore += 1
        setScoreLabelTextTo(text: String(self.currentScore))
    }
    func setScoreLabelTextTo(text: String){
        self.scoreLabel.text = text
    }
    
    //MARK: - Shoot methods
    //
    func shoot(){
        if birdIsShooting {
            return
        }else{
            birdIsShooting = true
            
            let pooNode = SKSpriteNode(imageNamed: "poo")
            pooNode.position = self.pooSpawnPosition
            pooNode.physicsBody = SKPhysicsBody(rectangleOf: pooNode.frame.size)
            pooNode.physicsBody?.categoryBitMask = PhysicsCategory.Bullet.rawValue
            pooNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
            pooNode.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
            pooNode.physicsBody?.fieldBitMask = PhysicsCategory.Field.rawValue
            pooNode.name = "pooNode"
            
            self.fg.addChild(pooNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !levelIsInGameState{
            return
        }
        shoot()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("didBegin(_ contact: SKPhysicsContact)")
        
        let collisionBitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        var pooNode: SKNode?
        if contact.bodyA.node?.name == "pooNode" {
            pooNode = contact.bodyA.node
        }else if contact.bodyB.node?.name == "pooNode" {
            pooNode = contact.bodyB.node
        }
        
        if collisionBitMask == PhysicsCategory.Bullet.rawValue | PhysicsCategory.Human.rawValue{
            pooNode?.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
            pooNode?.removeFromParent()
            increaseScore()
            self.birdIsShooting = false
        }else if collisionBitMask == PhysicsCategory.Bullet.rawValue | PhysicsCategory.Edge.rawValue{
            pooNode?.removeFromParent()
            resetScore()
            self.birdIsShooting = false
        }
    }
    
}
