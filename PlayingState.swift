//
//  PlayingState.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/28/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        print("entered into Playing State")
        
        hitTop = false
        playing = true
        movementAllowed = true
        print(movementAllowed)
        
     
        if previousState is InstructionsState {
            
            scene.initialJimmyScaleUp()

        }
        
        scene.startSpawningObstacle()
        
        
        scene.player.animationComponent.startAnimation()
        
        //scene.playMusic()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == FallingState.self) || (stateClass == GameOverState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.updateBackground()
        scene.updateForeground()
        scene.updateScoreLabel()
    }
}
