//
//  BaseSKScene.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import SpriteKit
import GameplayKit

/// Base Scene of all levels in game. All game logic & stuff is  here(BaseSKScene);
/// Animation, Particle effects & other background stuff is in custom children.
class BaseSKScene: SKScene {
    
    //MARK: - Properties
    //
    //TODO: run through all properties & delete not used ones
    //TODO: sort & MARK all properties by usage category
    var currentBird: Bird!
    var birdNode: BirdSKSpriteNode!
    var birdNodes = [BirdSKSpriteNode]()
    var currentLevel: Level!
    
    let shootableNodes: [PhysicsCategory] = [.Egg, .Egg, .Egg, .Egg, .Egg, .Egg, .Egg, .Poo, .Poo, .Bonus]
    let indexRandomizer = GKShuffledDistribution(lowestValue: 0, highestValue: 2)
    
    var bg: SKNode!
    var fg: SKNode!
    
    var eggNode: SKSpriteNode!
    var bonusNode: SKSpriteNode!
    var pooNode: SKSpriteNode!
    
    let sparklesWhiteEmitter = SKEmitterNode(fileNamed: "SparklesWhiteEmitter")
    let sparklesGoldEmitter  = SKEmitterNode(fileNamed: "SparklesGoldEmitter")
    let sparklesBrownEmitter = SKEmitterNode(fileNamed: "SparklesBrownEmitter")
    let explosionWhiteEmitter = SKEmitterNode(fileNamed: "ExplosionWhiteEmitter")
    let explosionGoldEmitter = SKEmitterNode(fileNamed: "ExplosionGoldEmitter")
    let explosionBrownEmitter = SKEmitterNode(fileNamed: "ExplosionBrownEmitter")
    
    var mainHeroNode: SKSpriteNode!
    
    var currentScore = 0
    var currentStreak = 1
    var isLevelInGameState = false
    var isFirstTouch = true
    
    // enemy spawn proerties
    let difficultyIncreaseTimeStep: TimeInterval = 5.0
    let enemySpawnDelayDefault: TimeInterval = 1.5
    var enemySpawnDelay: TimeInterval = 0.5
    let enemySpawnDelayDecreaseStep: TimeInterval = 0.05
    let enemySpawnDelayMinValue: TimeInterval = 0.5
    var spawnSequence = [SKAction]()
    
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
    var widthOfVisibleAreaThird: CGFloat = 0
    var centerBirdNodePosition = CGPoint(x: 0, y: 680)
    var birdNodePositions = [CGPoint]()
    
    var tapHereNodesContainerNode: SKNode!
    let tapHereAnimationSpeed: TimeInterval = 0.5
    

    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        // scene unfroze fix, just in case
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
        
        setupSpawnDelayActionsSequence()
        
        setupEggNode()
        setupPooNode()
        setupBonusNode()
        setupMainHero()
        
        setupDestinationProperties()
        setupEdgeProperties()
        
        setupTapHereNodes()
    }
    
    //MARK: - Setup methods
    //
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
        
        widthOfVisibleAreaThird = widthOfVisibleArea / 3
        birdNodePositions = [
            CGPoint(x: -widthOfVisibleAreaThird, y: centerBirdNodePosition.y),
            centerBirdNodePosition,
            CGPoint(x: widthOfVisibleAreaThird, y: centerBirdNodePosition.y)
        ]
        
        print("Edges:\nLeft Edge \(leftEdge)\nRight Edge \(rightEdge)")
        print("VisibleAreaWidth = \(widthOfVisibleArea)")
        print("EdgeXCoordinates:\nleft = \(sceneLeftEdgeXCoordinate)\nright = \(sceneRightEdgeXCoordinate)")
        print("MinMaxCoordinates:\nmin = \(minHeroXCoordinate)\nmax = \(maxHeroXCoordinate)")
    }
    
    func setupTapHereNodes(){
        tapHereNodesContainerNode = SKNode()
        tapHereNodesContainerNode.position = CGPoint(x: 0, y: 0)
        tapHereNodesContainerNode.zPosition = 10
        tapHereNodesContainerNode.alpha = 0
        self.fg.addChild(tapHereNodesContainerNode)
        
        let tapHereCenterNode = SKSpriteNode(imageNamed: "tapHereCenterIcon")
        let tapHereLeftNode = SKSpriteNode(imageNamed: "tapHereLeftIcon")
        let tapHereRightNode = SKSpriteNode(imageNamed: "tapHereRightIcon")
        
        let halfOfTapNodeWidth = tapHereCenterNode.frame.width / 2
        let tapHereSpawnY = enemySpawnY  + halfOfTapNodeWidth
        
        tapHereLeftNode.position = CGPoint(x: birdNodePositions[0].x, y: tapHereSpawnY)
        tapHereCenterNode.position = CGPoint(x: birdNodePositions[1].x, y: tapHereSpawnY)
        tapHereRightNode.position = CGPoint(x: birdNodePositions[2].x, y: tapHereSpawnY)
        
        let resizeForeverAnimationAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.5, duration: tapHereAnimationSpeed),
            SKAction.scale(to: 0.75, duration: tapHereAnimationSpeed)
            ]))
        
        tapHereNodesContainerNode.addChild(tapHereLeftNode)
        tapHereNodesContainerNode.addChild(tapHereCenterNode)
        tapHereNodesContainerNode.addChild(tapHereRightNode)
        
        tapHereLeftNode.run(resizeForeverAnimationAction)
        tapHereCenterNode.run(resizeForeverAnimationAction)
        tapHereRightNode.run(resizeForeverAnimationAction)
    }
    
    func setupEggNode(){
        eggNode = SKSpriteNode(imageNamed: "egg")
        eggNode.physicsBody = SKPhysicsBody(rectangleOf: eggNode.frame.size)
        eggNode.physicsBody?.categoryBitMask = PhysicsCategory.Egg.rawValue
        eggNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
        eggNode.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
        eggNode.physicsBody?.fieldBitMask = PhysicsCategory.Field.rawValue
        eggNode.name = "shootableNode"
        let eggSparklesEmitter = self.sparklesWhiteEmitter?.copy() as! SKEmitterNode
        eggNode.addChild(eggSparklesEmitter)
    }
    func setupBonusNode(){
        bonusNode = SKSpriteNode(imageNamed: "bonus")
        bonusNode.physicsBody = SKPhysicsBody(rectangleOf: bonusNode.frame.size)
        bonusNode.physicsBody?.categoryBitMask = PhysicsCategory.Bonus.rawValue
        bonusNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
        bonusNode.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
        bonusNode.physicsBody?.fieldBitMask = PhysicsCategory.Field.rawValue
        bonusNode.name = "shootableNode"
        let bonusSparklesEmitter = self.sparklesGoldEmitter?.copy() as! SKEmitterNode
        bonusNode.addChild(bonusSparklesEmitter)
    }
    func setupPooNode(){
        pooNode = SKSpriteNode(imageNamed: "poo")
        pooNode.physicsBody = SKPhysicsBody(rectangleOf: pooNode.frame.size)
        pooNode.physicsBody?.categoryBitMask = PhysicsCategory.Poo.rawValue
        pooNode.physicsBody?.collisionBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
        pooNode.physicsBody?.contactTestBitMask = PhysicsCategory.Edge.rawValue | PhysicsCategory.Human.rawValue
        pooNode.physicsBody?.fieldBitMask = PhysicsCategory.Field.rawValue
        pooNode.name = "shootableNode"
        let pooSparklesEmitter = self.sparklesBrownEmitter?.copy() as! SKEmitterNode
        pooNode.addChild(pooSparklesEmitter)
    }
    func setupMainHero(){
        mainHeroNode = EnemySKSpriteNode(self.currentLevel.enemies[0], self.rightDestinationX)
        mainHeroNode.position = CGPoint(x: self.leftDestinationX, y: self.enemySpawnY + mainHeroNode.frame.height / 2)
        mainHeroNode.zPosition = 1
        self.fg.addChild(mainHeroNode)
    }
    func setupSpawnDelayActionsSequence(){
        spawnSequence = [SKAction]()
        let spawnAction = SKAction.run {
            self.shoot()
        }
        for delay in stride(from: enemySpawnDelayDefault, to: enemySpawnDelayMinValue, by: -enemySpawnDelayDecreaseStep) {
            spawnSequence.append(spawnAction)
            spawnSequence.append(SKAction.wait(forDuration: delay))
        }
        spawnSequence.append(SKAction.repeatForever(SKAction.sequence([
            spawnAction,
            SKAction.wait(forDuration: enemySpawnDelayMinValue)
            ])))
    }
    
    //MARK: - Game methods
    //
    func startGame(){
        self.isPaused = false
        self.isLevelInGameState = true
        // update score & streak labels
        startSpawning()
    }
    func pauseGame(){
        self.isPaused = true
    }
    func continueGame(){
        self.isPaused = false
    }
    func stopGame(){
        self.isLevelInGameState = false
        self.isFirstTouch = true
        self.isPaused = false
        stopSpawning()
    }
    
    //MARK: - Spawn methods
    //
    func startSpawning(){
        self.enemySpawnDelay = self.enemySpawnDelayDefault
        startSequentialEnemiesSpawning()
    }
    func stopSpawning(){
        removeAction(forKey: difficultyTimerKey)
        removeAction(forKey: spawnKey)
        self.fg.enumerateChildNodes(withName: "//shootableNode") { (node, nil) in
            node.removeFromParent()
        }
    }
    
    private func startSequentialEnemiesSpawning(){
        print("startSequentialEnemiesSpawning called")
        removeAction(forKey: spawnKey)
        self.run(SKAction.sequence(spawnSequence), withKey: spawnKey)
    }
    
    //MARK: - Score methods
    //
    func resetScore(){
        print("resetScore called")
        stopGame()
        self.currentScore = 0
        self.currentStreak = 1
        Settings.shared.amountOfLoses += 1
        Settings.shared.save()
    }
    func increaseScore(){
        print("increaseScore called")
        self.currentScore += 1 * currentStreak
        
        Settings.shared.totalScore += 1 * UInt(currentStreak)
        if currentScore > Settings.shared.bestScore{
            Settings.shared.bestScore = UInt(currentScore)
        }
        Settings.shared.save()
    }
    func increaseStreak(){
        print("increaseStreak called")
        self.currentStreak += 1
    }
    //MARK: - Emitter methods
    //
    func addExplosionOfType(_ type: PhysicsCategory, atPoint point: CGPoint){
        let explosionEmitter: SKEmitterNode
        if type == .Egg{
            explosionEmitter = explosionWhiteEmitter?.copy() as! SKEmitterNode
        }else if type == .Poo{
            explosionEmitter = explosionBrownEmitter?.copy() as! SKEmitterNode
        }else{
            explosionEmitter = explosionGoldEmitter?.copy() as! SKEmitterNode
        }
        explosionEmitter.position = point
        self.fg.addChild(explosionEmitter)
        explosionEmitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.removeFromParent()
            ]))
    }
    //MARK: - Shoot methods
    //
    func shoot(){
        let shootableNode: SKSpriteNode
        let shooterIndex = indexRandomizer.nextInt()
        
        let shootableNodeType = shootableNodes.randomElement()!
        if shootableNodeType == .Egg {
            shootableNode = eggNode.copy() as! SKSpriteNode
        }else if shootableNodeType == .Poo {
            shootableNode = pooNode.copy() as! SKSpriteNode
        }else{
            shootableNode = bonusNode.copy() as! SKSpriteNode
        }
        
        shootableNode.position = birdNodePositions[shooterIndex]
        birdNodes[shooterIndex].shoot()
        self.fg.addChild(shootableNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan called from baseGameScene")
        if isFirstTouch{
            isFirstTouch = false
            hideTapHereContainer()
            startGame()
            return
        }
        if !isLevelInGameState{
            return
        }
        
        guard let touchPoint = touches.first?.location(in: self) else {return}
        if touchPoint.x > widthOfVisibleAreaThird / 2 {
            // right
            mainHeroNode.run(SKAction.move(to: CGPoint(x: widthOfVisibleAreaThird, y: mainHeroNode.position.y), duration: 0.5))
        }else if touchPoint.x < widthOfVisibleAreaThird / 2 && touchPoint.x > -widthOfVisibleAreaThird / 2 {
            // center
            mainHeroNode.run(SKAction.move(to: CGPoint(x: 0, y: mainHeroNode.position.y), duration: 0.5))
        }else{
            // left
            mainHeroNode.run(SKAction.move(to: CGPoint(x: -widthOfVisibleAreaThird, y: mainHeroNode.position.y), duration: 0.5))
        }
    }
    
    //MARK: - Bird methods
    //
    func presentCurrentBird(){
        birdNodes.removeAll()
        self.fg.enumerateChildNodes(withName: "//birdNode") { (node, nil) in
            node.removeFromParent()
        }
        
        for i in 0..<3 {
            let bird = BirdSKSpriteNode(self.currentBird)
            bird.position = birdNodePositions[i]
            bird.zPosition = 1
            bird.startIdleAnimation()
            birdNodes.append(bird)
            self.fg.addChild(bird)
        }
    }
    
    //MARK: - TapHere methods
    //
    func unhideTapHereContainer(){
        mainHeroNode.run(SKAction.move(to: CGPoint(x: 0, y: mainHeroNode.position.y), duration: 0.5))
        NotificationCenter.default.post(name: .resetScoreAndStreak, object: nil)
        let fadeInAnimationAction = SKAction.fadeIn(withDuration: tapHereAnimationSpeed)
        tapHereNodesContainerNode.isHidden = false
        tapHereNodesContainerNode.run(fadeInAnimationAction)
    }
    
    func hideTapHereContainer(){
        let fadeOutAnimationAction = SKAction.fadeOut(withDuration: tapHereAnimationSpeed)
        tapHereNodesContainerNode.run(fadeOutAnimationAction)
        tapHereNodesContainerNode.isHidden = true
    }
    
}

//MARK: - PhysicsContact
extension BaseSKScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("didBegin(_ contact: SKPhysicsContact)")
        
        let collisionBitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        var shootableNode: SKNode?
        var enemyNode: EnemySKSpriteNode?
        let contactPoint = contact.contactPoint
        
        if contact.bodyA.node?.name == "shootableNode" {
            shootableNode = contact.bodyA.node
        }else if contact.bodyB.node?.name == "shootableNode" {
            shootableNode = contact.bodyB.node
        }
        if contact.bodyA.node?.name == "enemyNode" {
            enemyNode = contact.bodyA.node as? EnemySKSpriteNode
        }else if contact.bodyB.node?.name == "enemyNode" {
            enemyNode = contact.bodyB.node as? EnemySKSpriteNode
        }
        
        if collisionBitMask == PhysicsCategory.Egg.rawValue | PhysicsCategory.Human.rawValue{
            shootableNode?.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
            shootableNode?.removeFromParent()
            addExplosionOfType(.Egg, atPoint: contact.contactPoint)
            // enemyNode?.runCatchAnimation()
            increaseScore()
            NotificationCenter.default.post(name: .setupScoreKey, object: currentScore)
        }
        else if collisionBitMask == PhysicsCategory.Egg.rawValue | PhysicsCategory.Edge.rawValue{ // GAME OVER
            shootableNode?.removeFromParent()
            addExplosionOfType(.Egg, atPoint: contactPoint)
            resetScore()
            
            NotificationCenter.default.post(name: .showGameOverKey, object: nil)
        }
        else if collisionBitMask == PhysicsCategory.Bonus.rawValue | PhysicsCategory.Human.rawValue{
            shootableNode?.removeFromParent()
            addExplosionOfType(.Bonus, atPoint: contactPoint)
            increaseStreak()
            NotificationCenter.default.post(name: .setupStreak, object: currentStreak)
        }
        else if collisionBitMask == PhysicsCategory.Bonus.rawValue | PhysicsCategory.Edge.rawValue {
            shootableNode?.removeFromParent()
            addExplosionOfType(.Bonus, atPoint: contactPoint)
        }
        else if collisionBitMask == PhysicsCategory.Poo.rawValue | PhysicsCategory.Human.rawValue { // GAME OVER
            shootableNode?.removeFromParent()
            addExplosionOfType(.Poo, atPoint: contactPoint)
            resetScore()
            NotificationCenter.default.post(name: .showGameOverKey, object: nil)
        }
        else if collisionBitMask == PhysicsCategory.Poo.rawValue | PhysicsCategory.Edge.rawValue {
            shootableNode?.removeFromParent()
            addExplosionOfType(.Poo, atPoint: contactPoint)
        }
    }
    
}
