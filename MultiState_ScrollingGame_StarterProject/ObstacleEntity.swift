//
//  Obstacle.swift
//  MultiState_ScrollingGame_StarterProject
//
//  Created by Craig Anthony on 2/24/17.
//  Copyright © 2017 CASM Group, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Obstacle: GKEntity {
    
    var spriteComponent: SpriteComponent!
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        let spriteNode = spriteComponent.node
        
        let offsetX = spriteNode.frame.size.width * spriteNode.anchorPoint.x;
        let offsetY = spriteNode.frame.size.height * spriteNode.anchorPoint.y;
        let path = CGMutablePath();
        
        path.move(to: CGPoint(x: 64 - offsetX, y: 271 - offsetY))
        path.addLine(to: CGPoint(x: 64 - offsetX, y: 0 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y: 1 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y: 290 - offsetY))
        path.addLine(to: CGPoint(x: 7 - offsetX, y: 315 - offsetY))
        path.addLine(to: CGPoint(x: 19 - offsetX, y: 315 - offsetY))
        path.addLine(to: CGPoint(x: 29 - offsetX, y: 293 - offsetY))
        path.addLine(to: CGPoint(x: 41 - offsetX, y: 308 - offsetY))
        path.addLine(to: CGPoint(x: 42 - offsetX, y: 310 - offsetY))
        path.addLine(to: CGPoint(x: 57 - offsetX, y: 303 - offsetY))
        
        path.closeSubpath()
        
        spriteNode.physicsBody = SKPhysicsBody(polygonFrom: path)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

