//
//  Box.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class Block {
    static let BLOCK_SIZE:CGFloat = 0.8
    static let BLOCK_CHAMFER_RADIUS:CGFloat = 0//0.05
    static let BLOCK_OFFSET:CGFloat = 2.5
    
    // box textures modified slightly from:
    // http://critical-gaming.com/blog/2013/2/25/new-super-mario-bros-2-a-game-design-medley.html
    
    // we cant cache using the boxtype as the key because it has associated values (thus
    // not hashable..)
    private static var cachedGeometry = [String:SCNBox]()
    
    class func solidMaterial() -> SCNMaterial {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/block/solid_block_flat_black.png")
        mat.normal.contents = UIImage(named: "art.scnassets/block/solid_block_flat_normal.png")
        mat.displacement.contents = UIImage(named: "art.scnassets/block/solid_block_flat_displacement.png")
        
        return mat
    }
    
    class func powerUpMaterial() -> SCNMaterial {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/block/question_block-flat_black.png")
        mat.normal.contents = UIImage(named: "art.scnassets/block/question_block-flat_normal.png")
        mat.displacement.contents = UIImage(named: "art.scnassets/block/question_block-flat_displacement.png")
        
        return mat
    }
    
    class func usedPowerUpMaterial() -> SCNMaterial {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/block/used_question_block-flat_black.png")
        mat.normal.contents = UIImage(named: "art.scnassets/block/used_question_block-flat_normal.png")
        mat.displacement.contents = UIImage(named: "art.scnassets/block/used_question_block_flat_displacement.png")
        
        return mat
    }
    
    class func destrucableMaterial() -> SCNMaterial {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/block/breakable_block-flat_black.png")
        mat.normal.contents = UIImage(named: "art.scnassets/block/breakable_block-flat_normal.png")
        mat.displacement.contents = UIImage(named: "art.scnassets/block/breakable_block-flat_displacement.png")
        
        return mat
    }
    
    class func node(boxType:BlockType) -> SCNNode {
        let node = SCNNode()
        
        let cacheKey:String
        switch boxType {
        case .solid: cacheKey = "solid"
        case .powerUp: cacheKey = "powerUp"
        case .usedPowerUp: cacheKey = "usedPowerUp"
        case .destructible: cacheKey = "destructible"
        }
        
        if cachedGeometry[cacheKey] == nil {
            let boxGeometry = SCNBox(width: BLOCK_SIZE,
                                     height: BLOCK_SIZE,
                                     length: BLOCK_SIZE,
                                     chamferRadius: BLOCK_CHAMFER_RADIUS)
            boxGeometry.widthSegmentCount = 25
            boxGeometry.heightSegmentCount = 25
            boxGeometry.lengthSegmentCount = 25
            switch boxType {
            case .solid: boxGeometry.firstMaterial = solidMaterial()
            case .powerUp: boxGeometry.firstMaterial = powerUpMaterial()
            case .usedPowerUp: boxGeometry.firstMaterial = usedPowerUpMaterial()
            case .destructible: boxGeometry.firstMaterial = destrucableMaterial()
            }
            cachedGeometry[cacheKey] = boxGeometry
        }
        
        let boxNode = SCNNode(geometry: cachedGeometry[cacheKey]!)
        boxNode.position = SCNVector3(0, 0.5 * BLOCK_SIZE, 0)
        
        boxNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                              shape: nil)
        boxNode.physicsBody!.categoryBitMask = CollisionTypes.box.rawValue|CollisionTypes.solid.rawValue
        boxNode.physicsBody!.collisionBitMask = CollisionTypes.fireball.rawValue
        boxNode.physicsBody!.contactTestBitMask = CollisionTypes.player.rawValue
        
        node.addChildNode(boxNode)
        
        
        
        if case .powerUp(_) = boxType {
            node.eulerAngles = SCNVector3(0,0,-CGFloat(10.0.degreesToRadians))
        let rotateAction1 = SCNAction.rotateBy(x: 0,
                                              y: 0,
                                              z: CGFloat(20.0.degreesToRadians),
                                              duration: 1)
        let rotateAction2 = SCNAction.rotateBy(x: 0,
                                               y: 0,
                                               z: -CGFloat(20.0.degreesToRadians),
                                               duration: 1)
        let sequence = SCNAction.sequence([rotateAction1,rotateAction2])
        let repeatAction = SCNAction.repeatForever(sequence)
        node.runAction(repeatAction)
        
        }
        return node
    }
}
