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
    //MARK: Custom nodes
    var currentHero: Hero!
    var mainHeroNode: HeroSKSpriteNode!
    var birdNodes = [BirdSKSpriteNode]()
    var currentLevel: Level!
    
    //MARK: Shoot randomization properties
    let shootableNodes: [PhysicsCategory] = [.Egg, .Egg, .Egg, .Egg, .Egg, .Egg, .Egg, .Poo, .Poo, .Bonus]
    let indexRandomizer = GKShuffledDistribution(lowestValue: 0, highestValue: 2)
    
    //MARK: Foreground & Background
    var bg: SKNode!
    var fg: SKNode!
    
    //MARK: Copiable nodes
    var eggNode: SKSpriteNode!
    var bonusNode: SKSpriteNode!
    var pooNode: SKSpriteNode!
    
    //MARK: Copiable emitter nodes
    let sparklesWhiteEmitter = SKEmitterNode(fileNamed: "SparklesWhiteEmitter")
    let sparklesGoldEmitter  = SKEmitterNode(fileNamed: "SparklesGoldEmitter")
    let sparklesBrownEmitter = SKEmitterNode(fileNamed: "SparklesBrownEmitter")
    let explosionWhiteEmitter = SKEmitterNode(fileNamed: "ExplosionWhiteEmitter")
    let explosionGoldEmitter = SKEmitterNode(fileNamed: "ExplosionGoldEmitter")
    let explosionBrownEmitter = SKEmitterNode(fileNamed: "ExplosionBrownEmitter")
    
    //MARK: Game properties
    var currentScore = 0
    var currentStreak = 1
    var isLevelInGameState = false
    var isFirstTouch = true
    
    //MARK: Spawn properties
    let spawnDelayMaxValue: TimeInterval = 1.5
    let spawnDelayDecreaseStep: TimeInterval = 0.05
    let spawnDelayMinValue: TimeInterval = 0.5
    var spawnSequence = [SKAction]()
    let spawnKey = "SpawnKey"
    var enemySpawnY: CGFloat = 0
    var widthOfVisibleAreaThird: CGFloat = 0
    var centerBirdNodePosition = CGPoint(x: 0, y: 680)
    var birdNodePositions = [CGPoint]()
    
    //MARK: Scene size properties
    var sceneWidth: CGFloat     = 2560
    var sceneHeight: CGFloat    = 2560
    
    var minHeroXCoordinate: CGFloat = 0
    var maxHeroXCoordinate: CGFloat = 0
    var minHeroYCoordinate: CGFloat = 0
    var maxHeroYCoordinate: CGFloat = 0
    
    //MARK: Tap Here properties
    var tapHereNodesContainerNode: SKNode!
    let tapHereAnimationSpeed: TimeInterval = 0.5
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        // scene unfreeze fix, just in case
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
        
        setupEdgeProperties()
        setupCurrentBirds()
        setupTapHereNodes()
    }
    
    //MARK: - Setup methods
    //
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
        eggNode.addGlow(radius: 128)
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
        bonusNode.addGlow(radius: 128)
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
        self.fg.enumerateChildNodes(withName: "//heroNode") { (node, nil) in
            node.removeFromParent()
        }
        mainHeroNode = HeroSKSpriteNode(currentHero)
        mainHeroNode.position = CGPoint(x: 0, y: self.enemySpawnY + mainHeroNode.frame.height / 2)
        mainHeroNode.zPosition = 1
        self.fg.addChild(mainHeroNode)
    }
    func setupCurrentBirds(){
        birdNodes.removeAll()
        self.fg.enumerateChildNodes(withName: "//birdNode") { (node, nil) in
            node.removeFromParent()
        }
        
        for i in 0..<3 {
            let bird = BirdSKSpriteNode(self.currentLevel.bird)
            bird.position = birdNodePositions[i]
            bird.zPosition = 1
            bird.startIdleAnimation()
            birdNodes.append(bird)
            self.fg.addChild(bird)
        }
    }
    func setupSpawnDelayActionsSequence(){
        let spawnAction = SKAction.run {
            self.shoot()
        }
        for delay in stride(from: spawnDelayMaxValue, to: 1.25, by: -spawnDelayDecreaseStep) {
            spawnSequence.append(spawnAction)
            spawnSequence.append(SKAction.wait(forDuration: delay))
        }
        for delay in stride(from: 1.25, to: 0.75, by: -spawnDelayDecreaseStep / 2) {
            spawnSequence.append(spawnAction)
            spawnSequence.append(SKAction.wait(forDuration: delay))
        }
        for delay in stride(from: 0.75, to: spawnDelayMinValue, by: -spawnDelayDecreaseStep) {
            spawnSequence.append(spawnAction)
            spawnSequence.append(SKAction.wait(forDuration: delay))
        }
        spawnSequence.append(SKAction.repeatForever(SKAction.sequence([
            spawnAction,
            SKAction.wait(forDuration: spawnDelayMinValue)
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
        self.isPaused = false
        stopSpawning()
    }
    
    //MARK: - Spawn methods
    //
    func startSpawning(){
        startSequentialNodeSpawning()
    }
    func stopSpawning(){
        removeAction(forKey: spawnKey)
        self.fg.enumerateChildNodes(withName: "//shootableNode") { (node, nil) in
            node.removeFromParent()
        }
    }
    
    private func startSequentialNodeSpawning(){
        removeAction(forKey: spawnKey)
        self.run(SKAction.sequence(spawnSequence), withKey: spawnKey)
    }
    
    //MARK: - Score methods
    //
    func resetScore(){
        stopGame()
        self.currentScore = 0
        self.currentStreak = 1
        Settings.shared.amountOfLoses += 1
        Settings.shared.save()
    }
    func increaseScore(){
        self.currentScore += 1 * currentStreak
        
        Settings.shared.totalScore += 1 * UInt(currentStreak)
        if currentScore > Settings.shared.bestScore{
            Settings.shared.bestScore = UInt(currentScore)
        }
        Settings.shared.save()
    }
    func increaseStreak(){
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
    
    //MARK: - TapHere methods
    //
    func unhideTapHereContainer(){
        self.isFirstTouch = true
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
        let contactPoint = contact.contactPoint
        
        if contact.bodyA.node?.name == "shootableNode" {
            shootableNode = contact.bodyA.node
        }else if contact.bodyB.node?.name == "shootableNode" {
            shootableNode = contact.bodyB.node
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
            shootableNode?.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
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
