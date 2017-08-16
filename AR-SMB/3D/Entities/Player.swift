//
//  Player.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 05/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class Player {
    static let RADIUS:CGFloat = 0.25
    static let HEIGHT:CGFloat = 1.8
    static let JUMP_ALTITUDE:CGFloat = 1
    
    class func node() -> SCNNode {
        let node = SCNNode()
        node.physicsBody = SCNPhysicsBody(type: .kinematic,
                                                 shape: SCNPhysicsShape(geometry: SCNCylinder(radius: RADIUS, height: HEIGHT),
                                                                        options: nil))
        node.physicsBody!.categoryBitMask = CollisionTypes.player.rawValue
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.contactTestBitMask = CollisionTypes.coin.rawValue|CollisionTypes.box.rawValue|CollisionTypes.monster.rawValue|CollisionTypes.flagPoleBase.rawValue|CollisionTypes.pickup.rawValue|CollisionTypes.fireball.rawValue
        return node
    }
}
