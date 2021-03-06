//
//  AnimationComponent.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/24/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    
    let spriteComponent: SpriteComponent
    var textures: Array<SKTexture> = []
    
    init(entity: GKEntity, textures: Array<SKTexture>) {
        
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if movementAllowed {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    func startAnimation() {
        if !spriteComponent.node.hasActions() {
            let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
            spriteComponent.node.run(SKAction.repeatForever(playerAnimation))
        }
    }
    
    func stopAnimation(){
        spriteComponent.node.removeAllActions()
    }
    
}
