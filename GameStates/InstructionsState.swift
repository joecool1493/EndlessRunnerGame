//
//  InstructionsState.swift
//  TheEndlessRunner
//
//  Created by Joey Newfield on 1/22/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import SpriteKit
import GameplayKit

class InstructionsState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        print("Entered Instructions state")
        
        setupInstructions()
        
    }
    
    override func willExit(to nextState: GKState) {
        // Remove tutorial
        scene.worldNode.enumerateChildNodes(withName: "Tutorial", using: { node, stop in
            node.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
                ]))
        })
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func setupInstructions() {
        
        scene.setupBackground()
        scene.setupForeground()
        scene.setupPlayer()
        scene.setupScoreLabel()
        
        let tutorial = SKSpriteNode(imageNamed: "tapToStart")
        tutorial.position = CGPoint(x: scene.size.width * 0.5, y: scene.playableHeight * 0.4 + scene.playableStart)
        tutorial.name = "Tutorial"
        tutorial.zPosition = 10
        scene.worldNode.addChild(tutorial)
        
        let ready = SKSpriteNode(imageNamed: "ready")
        ready.position = CGPoint(x: scene.size.width * 0.5, y: scene.playableHeight * 0.7 + scene.playableStart)
        ready.name = "Tutorial"
        ready.zPosition = 10
        scene.worldNode.addChild(ready)
    }
}

