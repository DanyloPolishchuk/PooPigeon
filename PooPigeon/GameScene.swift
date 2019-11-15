//
//  GameScene.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/12/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var bg: SKNode!
    private var fg: SKNode!
    
    private var scoreLabel: SKLabelNode!
    private var currentScore = 0
    private var pooSpawnPosition: CGPoint!
    private var bird: SKSpriteNode!
    private var birdIsShooting = false
    private var human: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
        
        
        
        
//        let playableRect = CGRect(x: -screenWidth * 1.5 , y: -screenHeight * 1.5 ,
//                                  width: screenWidth * 3,
//                                  height: screenHeight * 3 )
        
        self.physicsWorld.contactDelegate = self
        
        self.bg = self.childNode(withName: "bg")
        self.fg = self.childNode(withName: "fg")
        
        self.bird = fg.childNode(withName: "bird") as? SKSpriteNode
        self.pooSpawnPosition = bird.position
        self.human = fg.childNode(withName: "humanNode") as? SKSpriteNode
        self.scoreLabel = fg.childNode(withName: "scoreLabelNode") as? SKLabelNode
        
        human.physicsBody?.categoryBitMask = PhysicsCategory.Human.rawValue
        human.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Bullet.rawValue
        human.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Bullet.rawValue
        
        let walkAction = SKAction.moveBy(x: 2000, y: 0, duration: 2.0)
        let humanWalkAction = SKAction.repeatForever(SKAction.sequence([
            walkAction,
            walkAction.reversed()
            ]))
        human.run(humanWalkAction)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.frame.width / 2,
                                                              y: -self.frame.height / 2,
                                                              width: self.frame.width,
                                                              height: self.frame.height))
        physicsBody?.categoryBitMask = PhysicsCategory.Edge.rawValue
        
        
    }
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
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
            
//            let pooNode = SKSpriteNode(texture: nil, color: UIColor.brown, size: CGSize(width: 10, height: 10))
            let pooNode = SKSpriteNode(imageNamed: "poo")
            pooNode.position = self.pooSpawnPosition
            pooNode.physicsBody = SKPhysicsBody(rectangleOf: pooNode.frame.size)
            pooNode.physicsBody?.categoryBitMask = PhysicsCategory.Bullet.rawValue
            pooNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
            pooNode.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
            pooNode.name = "pooNode"
            
            self.fg.addChild(pooNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        shoot()
        
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    
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
            increaseScore()
            pooNode?.removeFromParent()
            self.birdIsShooting = false
        }else if collisionBitMask == PhysicsCategory.Bullet.rawValue | PhysicsCategory.Edge.rawValue{
            resetScore()
            pooNode?.removeFromParent()
            self.birdIsShooting = false
        }
    }
    
    
//    func didBegin(_ contact: SKPhysicsContact) {
//
//        if contact.bodyA.categoryBitMask == PhysicsCategory.Label || contact.bodyB.categoryBitMask == PhysicsCategory.Label{
//            let labelNode = (contact.bodyA.contactTestBitMask == PhysicsCategory.Label) ? contact.bodyA.node : contact.bodyB.node
//            (labelNode as? MessageNode)?.didBounce()
//        }
//
//        if !playable{
//            return
//        }
//        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
//        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
//            print("SUCCESS")
//            win()
//        }else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge{
//            print("FAIL")
//            lose()
//        }
//        if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookNode?.isHooked == false {
//            hookNode?.hookNode(catNode)
//        }
//    }
    
    
}
