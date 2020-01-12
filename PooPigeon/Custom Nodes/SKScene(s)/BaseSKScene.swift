//
//  BaseSKScene.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import SpriteKit

/// Base Scene of all levels in game. All game logic & stuff is  here(BaseSKScene), animation, particle effects & stuff is in custom children.
class BaseSKScene: SKScene {
    
    //MARK: - Properties
    //
    var currentBird: Bird!
    var birdNode: BirdSKSpriteNode!
    var currentLevel: Level!
    
    var bg: SKNode!
    var fg: SKNode!
    
    var currentScore = 0
    var pooSpawnPosition: CGPoint!
    var birdIsShooting = false
    var levelIsInGameState = false
    
    // enemy spawn proerties
    let difficultyIncreaseTimeStep: TimeInterval = 5.0
    let enemySpawnDelayDefault: TimeInterval = 0.5
    var enemySpawnDelay: TimeInterval = 0.5
    let enemySpawnDelayIncreaseStep: TimeInterval = 0.25
    let enemySpawnDelayMaxValue: TimeInterval = 2.0
    
    var spawnKey = "SpawnKey"
    var difficultyTimerKey = "DifficultyTimerKey"
    
    // width & height are fixed throughout this project cause pixelArt levels are all the same size (320x320 px) multiplied by 8
    /// Width of scene
    var sceneWidth: CGFloat     = 2560
    /// Height of scene
    var sceneHeight: CGFloat    = 2560
    
    var minHeroXCoordinate: CGFloat = 0
    var maxHeroXCoordinate: CGFloat = 0
    var minHeroYCoordinate: CGFloat = 0
    var maxHeroYCoordinate: CGFloat = 0
    
    var leftDestinationX: CGFloat = 0
    var rightDestinationX: CGFloat = 0
    var enemySpawnY: CGFloat = 0


    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        // scene bug fix
        self.isPaused = true
        self.isPaused = false
        
        bg = self.childNode(withName: "bg")
        fg = self.childNode(withName: "fg")
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
                
            }
        }
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.frame.width,
                                                              y: -self.frame.height / 2 + 256,
                                                              width: self.frame.width * 2,
                                                              height: self.frame.height - 256))
        physicsBody?.categoryBitMask = PhysicsCategory.Edge.rawValue
        
        enemySpawnY = -self.frame.height / 2 + 256 + 5
        
        setupDestinationProperties()
    }
    
    func setupDestinationProperties(){
        if let enemy = currentLevel.enemies.first{
            let enemyNodeWidth = EnemySKSpriteNode(enemy, 0).frame.width / 2
            leftDestinationX = -sceneWidth / 2 - enemyNodeWidth
            rightDestinationX =  sceneWidth / 2 + enemyNodeWidth
        }
    }
    
    func setupEdgeProperties() {
        
        let newSceneWidth = (CGFloat(sceneWidth) * (view?.frame.height)!) / CGFloat(sceneHeight)
        let sceneDifference = (newSceneWidth - (view?.frame.width)! ) / 2
        let diffPercentage = sceneDifference / (newSceneWidth)
        
        let leftEdge = diffPercentage * CGFloat(sceneWidth)
        let rightEdge = CGFloat(sceneWidth) - (diffPercentage * CGFloat(sceneWidth))
        
        let widthOfVisibleArea = sceneWidth - leftEdge * 2
        let maximumHeroDistanceToEdge = widthOfVisibleArea / 2
        
        let sceneLeftEdgeXCoordinate: CGFloat = -(sceneWidth / 2)
        let sceneRightEdgeXCoordinate: CGFloat = sceneWidth / 2
        
        minHeroXCoordinate = sceneLeftEdgeXCoordinate + maximumHeroDistanceToEdge
        maxHeroXCoordinate = sceneRightEdgeXCoordinate - maximumHeroDistanceToEdge
        
        print("Edges:\nLeft Edge \(leftEdge)\nRight Edge \(rightEdge)")
        print("VisibleAreaWidth = \(widthOfVisibleArea)")
        print("EdgeXCoordinates:\nleft = \(sceneLeftEdgeXCoordinate)\nright = \(sceneRightEdgeXCoordinate)")
        print("MinMaxCoordinates:\nmin = \(minHeroXCoordinate)\nmax = \(maxHeroXCoordinate)")
    }
    
    //MARK: - Game methods
    //
    func startGame(){
        self.isPaused = false
        self.levelIsInGameState = true
        startSpawning()
    }
    func pauseGame(){
        self.isPaused = true
    }
    func continueGame(){
        self.isPaused = false
    }
    func stopGame(){
        self.levelIsInGameState = false
        self.isPaused = false
        stopSpawning()
    }
    
    //MARK: - Spawn methods
    //
    func startSpawning(){
        self.enemySpawnDelay = self.enemySpawnDelayDefault
        startDifficultyTimer()
    }
    func stopSpawning(){
        removeAction(forKey: difficultyTimerKey)
        removeAction(forKey: spawnKey)
    }
    
    private func createSequentialEnemies(){
        print("createSequentialEnemies called")
        removeAction(forKey: spawnKey)
        
        let spawnAction = SKAction.run {
            
            let enemyNode = EnemySKSpriteNode(self.currentLevel.enemies[0], self.rightDestinationX)
            enemyNode.position = CGPoint(x: self.leftDestinationX, y: self.enemySpawnY + enemyNode.frame.height / 2)
            enemyNode.zPosition = 1
            self.fg.addChild(enemyNode)
            enemyNode.walk()
            
        }
        let spawnDelayAction = SKAction.wait(forDuration: enemySpawnDelay)
        let spawnSequence = SKAction.sequence([
            spawnAction,
            spawnDelayAction
            ])
        self.run(SKAction.repeatForever(spawnSequence), withKey: spawnKey)
    }
    private func startDifficultyTimer(){
        print("startDifficultyTimer called")
        
        let waitAction = SKAction.wait(forDuration: difficultyIncreaseTimeStep)
        let increaseDifficultyAction = SKAction.run { [unowned self] in
            guard self.enemySpawnDelay < self.enemySpawnDelayMaxValue else {
                self.removeAction(forKey: self.difficultyTimerKey)
                return
            }
            self.enemySpawnDelay += self.enemySpawnDelayIncreaseStep
            self.createSequentialEnemies()
        }
        let increaseDifficultySequnce = SKAction.sequence([
            waitAction,
            increaseDifficultyAction
            ])
        self.run(SKAction.repeatForever(increaseDifficultySequnce), withKey: difficultyTimerKey)
    }
    
    //MARK: - Score methods
    //
    func resetScore(){
        print("resetScore called")
        stopGame()
        self.currentScore = 0
        Settings.shared.amountOfLoses += 1
        Settings.shared.save()
    }
    func increaseScore(){
        print("increaseScore called")
        self.currentScore += 1
        
        Settings.shared.totalScore += 1
        if currentScore > Settings.shared.bestScore{
            Settings.shared.bestScore = UInt(currentScore)
        }
        Settings.shared.save()
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
            
            birdNode.shoot()
            self.fg.addChild(pooNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        print("touchesBegan called from baseGameScene")
        
        if !levelIsInGameState{
            return
        }
        shoot()
    }
    
    //MARK: - next / prev level bird methods
    //
    func presentCurrentBird(){
        
        if let previousBird = self.childNode(withName: "//birdNode"){
            previousBird.removeFromParent()
        }
        let currentBird = BirdSKSpriteNode(self.currentBird)
        currentBird.position = self.currentBird.birdSpawnPosition
        self.pooSpawnPosition = self.currentBird.birdSpawnPosition
        currentBird.zPosition = 1
        currentBird.startIdleAnimation()
        birdNode = currentBird
        self.fg.addChild(currentBird)
        
    }
    
}


extension BaseSKScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("didBegin(_ contact: SKPhysicsContact)")
        
        let collisionBitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        var pooNode: SKNode?
        var enemyNode: EnemySKSpriteNode?
        if contact.bodyA.node?.name == "pooNode" {
            pooNode = contact.bodyA.node
        }else if contact.bodyB.node?.name == "pooNode" {
            pooNode = contact.bodyB.node
        }
        if contact.bodyA.node?.name == "enemyNode" {
            enemyNode = contact.bodyA.node as? EnemySKSpriteNode
        }else if contact.bodyB.node?.name == "enemyNode" {
            enemyNode = contact.bodyB.node as? EnemySKSpriteNode
        }
        
        if collisionBitMask == PhysicsCategory.Bullet.rawValue | PhysicsCategory.Human.rawValue{ // GAME CONTINUES
            pooNode?.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
            pooNode?.removeFromParent()
            enemyNode?.run()
            increaseScore()
            self.birdIsShooting = false
            
            NotificationCenter.default.post(name: .setupScoreKey, object: currentScore)
            
        }else if collisionBitMask == PhysicsCategory.Bullet.rawValue | PhysicsCategory.Edge.rawValue{ // GAME OVER
            pooNode?.removeFromParent()
            resetScore()
            self.birdIsShooting = false
            
            NotificationCenter.default.post(name: .showGameOverKey, object: nil)
        }
    }
    
}
