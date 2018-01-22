//
//  MainMenuState.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/28/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuState: GKState {
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        print("Entered MainMenuState")
        
        scene.setupBackground()
        scene.setupForeground()
        scene.setupPlayer()
        scene.setupScoreLabel()
       
        showMainMenu()
        
        movementAllowed = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is InstructionsState.Type
    }
    
    func showMainMenu() {
    
        let logo = SKSpriteNode(imageNamed: "titleLogo")
        logo.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.8)
        logo.zPosition = 10
        scene.worldNode.addChild(logo)
        
        let playButton = SKSpriteNode(imageNamed: "Button")
        playButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.6)
        playButton.zPosition = 10
        scene.worldNode.addChild(playButton)
        
        let play = SKSpriteNode(imageNamed: "Play")
        play.position = CGPoint.zero
        play.zPosition = 10
        playButton.addChild(play)
        
        let rateButton = SKSpriteNode(imageNamed: "Button")
        rateButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.6)
        rateButton.zPosition = 10
        scene.worldNode.addChild(rateButton)
        
        let rate = SKSpriteNode(imageNamed: "Rate")
        rate.position = CGPoint.zero
        rate.zPosition = 10
        rateButton.addChild(rate)
    }
}
