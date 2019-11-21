//
//  BaseSKScene.swift
//  PooPigeon
//
//  Created by Danylo Polishchuk on 11/21/19.
//  Copyright © 2019 Polishchuk company. All rights reserved.
//

import SpriteKit

class BaseSKScene: SKScene {
    
    //MARK: - Properties
    //
    var bird: Bird!
    var levelIsInGameState = false
    
    /// viewController that holds this scene view
    weak var viewController: UIViewController!
    
    /// Width of scene. Must be ovverriden in child
    var sceneWidth: CGFloat     = 0
    /// Height of scene. Must be ovverriden in child
    var sceneHeight: CGFloat    = 0
    
    var minHeroXCoordinate: CGFloat = 0
    var maxHeroXCoordinate: CGFloat = 0
    var minHeroYCoordinate: CGFloat = 0
    var maxHeroYCoordinate: CGFloat = 0
    
    /// background empty node that should be in every scene file
    var bg: SKNode!
    
    override func didMove(to view: SKView) {
        self.isPaused = true
        self.isPaused = false
        
        bg = self.childNode(withName: "bg")
        
        enumerateChildNodes(withName: "//*") { (node, _) in
            if let customNode = node as? CustomNodeEvents {
                customNode.didMoveToScene()
                
            }
        }
        
        
    }
    
    
    //TODO: make kinda same method (or just add two additional calculated properties here) that'd count edges for top & bottom edges (for scenes where hero'll move by Y).
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
    
//    func showTouchLocation( touchLocation: CGPoint) {
//        print("show called, touch position in scene: \(touchLocation)")
//        let circle = SKShapeNode(circleOfRadius: 75.0)
//        circle.position = touchLocation
//        circle.lineWidth = 7.0
//        circle.strokeColor = UIColor.white
//        circle.zPosition = 40
//
//        self.run(
//            SKAction.sequence([
//                SKAction.run {
//                    self.addChild(circle)
//                },
//                SKAction.wait(forDuration: 0.8),
//                SKAction.run {
//                    circle.removeFromParent()
//                }
//                ])
//        )
//    }
    
    //MARK: - random generation methods
    //
//    func runCloudGeneration(cloudSpawnFrequency: CloudSpawnFrequency){
//
//        let cloudGeneratorAction = SKAction.repeatForever(
//            SKAction.sequence([
//
//                SKAction.run {
//                    let cloudIndex = random(min: 0, max: 5)
//                    let cloud = SKSpriteNode(imageNamed: self.clouds[cloudIndex])
//
//                    let movementActionSequence = SKAction.sequence([
//                        SKAction.moveBy(x: self.sceneWidth + cloud.frame.width, y: 0, duration: 7),
//                        SKAction.run {
//                            cloud.removeFromParent()
//                        }
//                        ])
//
//                    cloud.position = CGPoint(x: -(self.sceneWidth / 2 + cloud.frame.width) ,
//                                             y: CGFloat(random(min: 0, max: 1280) - 640 ))
//                    cloud.zPosition = 1
//                    self.bg.addChild(cloud)
//                    cloud.run(movementActionSequence)
//                },
//                SKAction.wait(forDuration: cloudSpawnFrequency.rawValue)
//
//                ])
//        )
//
//        self.run(cloudGeneratorAction)
//    }
    
    //MARK: - touch methods
    //
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        guard let touchLocation = touches.first?.location(in: self) else {print("could not get touch location");return}
////        if shouldShowTouchLocation{
////            showTouchLocation(touchLocation: touchLocation)
////        }
//    }
    
}

