//
//  FireBall.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 05/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class Fireball {
    static let TTL:TimeInterval = 5
    static let INITIAL_VELOCITY:Float = 5
    static let RADIUS:CGFloat = Wand.TIP_RADIUS
    
    private static var sphere:SCNGeometry?
    
    class func node() -> SCNNode {
        
        if sphere == nil {
            sphere = SCNSphere(radius: RADIUS)
            sphere!.materials = [Wand.sphereMaterial(lavaType: .fast)]
        }
        /*
        let fireSys = SCNParticleSystem(named: "FireSys.scnp", inDirectory: nil)!
        fireSys.emitterShape = sphere
        */
        let node = SCNNode(geometry: sphere!)
        //let node = SCNNode()
       // node.addParticleSystem(fireSys)
        
        let body = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic,
                                  shape: nil)
        body.categoryBitMask = CollisionTypes.fireball.rawValue
        body.collisionBitMask = CollisionTypes.solid.rawValue
        body.contactTestBitMask = CollisionTypes.player.rawValue|CollisionTypes.monster.rawValue
        body.isAffectedByGravity = false
        body.mass = 0.5
        body.restitution = 0.5
        body.damping = 0.1
        body.friction = 0.8
        
        node.physicsBody = body
        
        return node
    }
}
