//
//  PlayerEntity.swift
//  TheEndlessRunner
//
//  Created by Joey Newfield on 1/22/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var spriteComponent: SpriteComponent!
    var movementComponent: MovementComponent!
    
    var animationComponent: AnimationComponent!
    var numberOfFrames = 3
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        movementComponent = MovementComponent(entity1: self)
        addComponent(movementComponent)
        
        movementComponent.applyInitialImpulse()
        
        var textures: Array<SKTexture> = []
        for i in 0..<numberOfFrames {
            textures.append(SKTexture(imageNamed: "fatJimmy\(i)"))
        }
        for i in stride(from: numberOfFrames, through: 0, by: -1) {
            textures.append(SKTexture(imageNamed: "fatJimmy\(i)"))
        }
        
        animationComponent = AnimationComponent(entity: self, textures: textures)
        addComponent(animationComponent)
        
        let spriteNode = spriteComponent.node
        
        let offsetX = spriteNode.frame.size.width * spriteNode.anchorPoint.x;
        let offsetY = spriteNode.frame.size.height * spriteNode.anchorPoint.y;
        let path = CGMutablePath();
        
        path.move(to: CGPoint(x: 0 - offsetX, y: 31 - offsetY))
        path.addLine(to: CGPoint(x: 43 - offsetX, y: 35 - offsetY))
        path.addLine(to: CGPoint(x: 56 - offsetX, y: 31 - offsetY))
        path.addLine(to: CGPoint(x: 58 - offsetX, y: 23 - offsetY))
        path.addLine(to: CGPoint(x: 59 - offsetX, y: 16 - offsetY))
        path.addLine(to: CGPoint(x: 52 - offsetX, y: 7 - offsetY))
        path.addLine(to: CGPoint(x: 27 - offsetX, y: 0 - offsetY))
        path.addLine(to: CGPoint(x: 7 - offsetX, y: 8 - offsetY))
        
        path.closeSubpath();
        
        spriteNode.physicsBody = SKPhysicsBody(polygonFrom: path)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

