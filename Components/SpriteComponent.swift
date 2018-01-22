//
//  SpriteComponent.swift
//  TheEndlessRunner
//
//  Created by Joey Newfield on 1/22/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import SpriteKit
import GameplayKit


class EntityNode: SKSpriteNode {
    weak var entity1: GKEntity?
}

class SpriteComponent: GKComponent {
    
    let node: EntityNode
    
    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = EntityNode(texture: texture, color: SKColor.white, size: size)
        node.entity1 = entity
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /////
    //////////
    ///////////////
}


