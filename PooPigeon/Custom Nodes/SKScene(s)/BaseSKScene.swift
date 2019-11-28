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
    var currentBird: Bird! {
        didSet{
            presentCurrentBird()
        }
    }
    var currentLevel: Level!
    var isNextBirdAvaliable: Bool!
    var isPreviousBirdAvaliable: Bool!
    
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
    
    //MARK: - next / prev level bird methods
    //
    func presentCurrentBird(){
        for bird in currentLevel.birds{
            if bird.birdName != currentBird.birdName {
                self.childNode(withName: "//\(bird.birdSceneFileName)")?.run(SKAction.hide())
            }else{
                self.childNode(withName: "//\(bird.birdSceneFileName)")?.run(SKAction.unhide())
            }
        }
    }
    
}

