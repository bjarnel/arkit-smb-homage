//
//  Monster.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 03/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit


class Monster {
    static let METERS_PER_SECOND:CGFloat = 2
    private static var _monsterNode:SCNNode?
    
    class func node() -> SCNNode {
        if _monsterNode == nil {
            guard let scene = SCNScene(named: "art.scnassets/monster/monster_sm_merged.dae"),
                  let node = scene.rootNode.childNode(withName: "Plane", recursively: true) else { fatalError() }
            
            _monsterNode = node
        }
        
        let monsterNode = _monsterNode!.clone()
        monsterNode.renderingOrder = 2
        monsterNode.eulerAngles = SCNVector3(0,0,-2.5.degreesToRadians)
        let rotatePosAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(5.0.degreesToRadians), duration: 0.35)
        let rotateNegAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(-5.0.degreesToRadians), duration: 0.35)
        let sequenceAction = SCNAction.sequence([rotatePosAction, rotateNegAction])
        let repeatAction = SCNAction.repeatForever(sequenceAction)
        monsterNode.runAction(repeatAction)
        
        
        monsterNode.scale = SCNVector3(0.23, 0.17, 0.23)
        monsterNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                                 shape: nil)
        monsterNode.physicsBody!.categoryBitMask = CollisionTypes.monster.rawValue
        monsterNode.physicsBody!.collisionBitMask = CollisionTypes.fireball.rawValue
        monsterNode.physicsBody!.contactTestBitMask = CollisionTypes.player.rawValue|CollisionTypes.fireball.rawValue
        
        let node = SCNNode()
        // should be rendered AFTER the FLOOR, that way we
        // should be able to push it into the ground!
        node.addChildNode(monsterNode)
        
        return node
    }
    
}
