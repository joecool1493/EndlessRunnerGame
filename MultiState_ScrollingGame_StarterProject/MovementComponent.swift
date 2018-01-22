//
//  MovementComponent.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/24/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit


class MovementComponent: GKComponent {
    
    let spriteComponent: SpriteComponent
    
    var velocity = CGPoint.zero
    
    var gravity: CGFloat = -1500
    var impulse: CGFloat = 400
    
    var velocityModifier: CGFloat = 1000.0
    var angularVelocity: CGFloat = 0.0
    let minDegrees: CGFloat = -90
    let maxDegrees: CGFloat = 25
    
    var lastTouchTime: TimeInterval = 0
    var lastTouchY: CGFloat = 0.0
    
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 650
    
    init(entity1: GKEntity) {
        
        self.spriteComponent = entity1.component(ofType: SpriteComponent.self)!
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyInitialImpulse(){
        print("Initial Impulse")
        velocity = CGPoint(x: 0, y: impulse * 2)
    }
    
    func applyImpulse(_ lastUpdateTime: TimeInterval) {
       
        print("impulse applied")
        
        velocity = CGPoint(x: 0, y: impulse)
        
        angularVelocity = velocityModifier.degreesToRadians()
        lastTouchTime = lastUpdateTime
        lastTouchY = spriteComponent.node.position.y
        
        
    }
    
    
    func applyMovement(_ seconds: TimeInterval) {
        
        let spriteNode = spriteComponent.node
        
        //Apply gravity
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds)
        velocity += gravityStep
        
        //Apply velocity
        
        let velocityStep = velocity * CGFloat(seconds)
        spriteNode.position += velocityStep
        
        if spriteNode.position.y < lastTouchY {
            angularVelocity = -velocityModifier.degreesToRadians()
        }
        
        //Rotate
        let angularStep = angularVelocity * CGFloat(seconds)
        spriteNode.zRotation += angularStep
        spriteNode.zRotation = min(max(spriteNode.zRotation, minDegrees.degreesToRadians()), maxDegrees.degreesToRadians())
        
        //Keeps player from falling through ground
        if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart + spriteNode.size.height / 2)
        }
        
        //height boundary...kill player
        if (spriteNode.position.y - spriteNode.size.height / 2) > (playableHeight + 50) {
            
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableHeight + spriteNode.size.height / 2)
            hitTop = true
            
        }
    }
 
 
    override func update(deltaTime seconds: TimeInterval) {
        
        if movementAllowed == true {
            
            applyMovement(seconds)
            //
        } else {
            //
        }
    }
    

    
}
