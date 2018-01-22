//
//  FallingState.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/28/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class FallingState: GKState {
    
    unowned let scene: GameScene
    
    let whackAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let fallingAction = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        print("Entered Falling State")
        
        //screen shake
        /*
        let shake = SKAction.screenShakeWithNode(scene.worldNode, amount: CGPoint(x: 0, y: 7.0), oscillations: 10, duration: 1.0)
        scene.worldNode.run(shake)
        
        let whiteNode = SKSpriteNode(color: SKColor.white, size: scene.size)
        whiteNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        whiteNode.zPosition = 20
        scene.worldNode.addChild(whiteNode)
        
        whiteNode.run(SKAction.removeFromParentAfterDelay(0.1))
        
        scene.run(SKAction.sequence([whackAction, SKAction.wait(forDuration: 0.1), fallingAction]))
        */
        
        scene.stopSpawningObstacle()
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //
    }
}
