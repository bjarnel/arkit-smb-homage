//
//  Floor.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 05/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class Floor {
    class func node() -> SCNNode {
        let floor = SCNFloor()
        floor.firstMaterial?.colorBufferWriteMask = SCNColorMask(rawValue: 0)
        floor.reflectivity = 0
        let floorNode = SCNNode(geometry: floor)
        
        floorNode.renderingOrder = 1
        floorNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        floorNode.physicsBody!.categoryBitMask = CollisionTypes.solid.rawValue
        floorNode.physicsBody!.collisionBitMask = CollisionTypes.fireball.rawValue
        floorNode.physicsBody!.contactTestBitMask = 0
        floorNode.physicsBody!.friction = 0.8
        return floorNode
    }
}
