//
//  FireballPowerUp.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 05/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

enum LavaMaterial {
    case fast
    case lavaPond
    case lavaBall
}

class Wand {
    static let SIZE:CGFloat = 0.6
    static let METERS_PER_SECOND:CGFloat = 0.5
    static let HANDLE_LENGTH:CGFloat = 0.5
    static let HANDLE_TOP_RADIUS:CGFloat = 0.03
    static let HANDLE_BOTTOM_RADIUS:CGFloat = 0.02
    
    // this size is kinda of trial an error in combination with the displacement map
    static let TIP_RADIUS:CGFloat = 0.06
    static let TIP_WITH_DISPLACEMENT_RADIUS:CGFloat = 0.01
    static let RECHARGE_TIME:TimeInterval = 0.25
    
    static let WAND_NODE_NAME = "wand"
    static let TIP_NODE_NAME = "tip"
    
    class func coneMaterials() -> [SCNMaterial] {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/wand/seamless_wood_texure_by_bhaskar655-d9y62za.jpg")
        mat.normal.contents = UIImage(named: "art.scnassets/wand/wand_stock_normal.png")
        
        // actually this displacement looks pretty good!
        mat.displacement.contents = UIImage(named: "art.scnassets/wand/wand_stock_displacement.png")
        
        let endMat = SCNMaterial()
        // https://www.flickr.com/photos/filterforge/8671761554
        endMat.diffuse.contents = UIImage(named: "art.scnassets/wand/wood_end.png")
        
        return [mat, endMat, endMat]
    }
    
    private static var lavaMaterials = [LavaMaterial:SCNMaterial]()
    
    class func sphereMaterial(lavaType:LavaMaterial) -> SCNMaterial {
        if lavaMaterials[lavaType] == nil {
            let mat = SCNMaterial()
            mat.diffuse.contents = UIImage(named: "art.scnassets/hole/lava_soft.png")
            mat.emission.contents = UIImage(named: "art.scnassets/hole/lava-e3.png")
            
            switch lavaType {
            case .fast:
                mat.normal.contents = UIImage(named: "art.scnassets/hole/lava_normal.png")
                
            case .lavaBall:
                
                mat.displacement.contents = UIImage(named: "art.scnassets/hole/lava_displacement.png")

                mat.shaderModifiers = [
                    //TODO: animation properties for this shader should be tweaked
                    .surface:Shaders.shared.emission
                ]
                
                mat.setValue(126.32, forKey: "baseScaler1")
                mat.setValue(106.32, forKey: "baseScaler2")
                mat.setValue(9.76, forKey: "scalingValue1")
                mat.setValue(12.23, forKey: "scalingValue2")
                
                
                //TODO: I think we need to replace geo_strange with something
                // more simple based on calculation in emission, and which may provide
                // dark spots "liftet" up - in exact relation to the emission animation?!?!
                //....would be awesome :-) IF possible
                //mat.setValue(0.005, forKey: "geomIntensity")
                //mat.setValue(20.8, forKey: "freq")
                //mat.setValue(20.0, forKey: "power")
                //mat.setValue(10.0, forKey: "factor")
                
                
                //sphereMat!.setValue(1, forKey: "allowNegative")
                //sphereMat!.setValue(500.0, forKey: "scaleUpFactor")
                //sphereMat!.setValue(0.005, forKey: "deformFactor")
                
                break
            case .lavaPond:
                mat.shaderModifiers = [
                    .geometry:Shaders.shared.geo_strange,
                    .surface:Shaders.shared.emission
                ]
                
                mat.setValue(0.3, forKey: "geomIntensity")
                mat.setValue(1.8, forKey: "freq")
                mat.setValue(4.0, forKey: "power")
                mat.setValue(1.0, forKey: "factor")
                
                mat.setValue(6.32, forKey: "baseScaler1")
                mat.setValue(6.32, forKey: "baseScaler2")
                mat.setValue(9.76, forKey: "scalingValue1")
                mat.setValue(12.23, forKey: "scalingValue2")
                
                
                //mat.setValue(0, forKey: "allowNegative")
                //mat.setValue(10.0, forKey: "scaleUpFactor")
                //mat.setValue(0.2, forKey: "deformFactor")
            }
            lavaMaterials[lavaType] = mat
            /*
            sphereMat = SCNMaterial()
            sphereMatFast = SCNMaterial()
            sphereMat!.diffuse.contents = UIImage(named: "art.scnassets/hole/lava_soft.png")
            sphereMatFast!.diffuse.contents = UIImage(named: "art.scnassets/hole/lava_soft.png")
            //sphereMatFast!.normal.contents = UIImage(named: "art.scnassets/hole/lava_normal.png")
            //sphereMatFast!.displacement.contents = UIImage(named: "art.scnassets/hole/lava_displacement.png")
            sphereMat!.emission.contents = UIImage(named: "art.scnassets/hole/lava-e3.png")
            sphereMatFast!.emission.contents = UIImage(named: "art.scnassets/hole/lava-e3.png")
            
            sphereMat!.shaderModifiers = [
                .geometry:Shaders.shared.geo_strange,
                .surface:Shaders.shared.emission
            ]
            
            // vec4 transformed_position = u_inverseModelTransform * u_inverseViewTransform * vec4(_surface.position, 1.0);

            // float factor = -1.0 * sin(u_time + scaleUpFactor * transformed_position.x + scaleUpFactor * transformed_position.y - transformed_position.z * scaleUpFactor);
            
            
            // for fireball
            //sphereMat!.setValue(1, forKey: "allowNegative")
            //sphereMat!.setValue(500.0, forKey: "scaleUpFactor")
            //sphereMat!.setValue(0.005, forKey: "deformFactor")
            
            // for lava plane
            sphereMat!.setValue(0, forKey: "allowNegative")
            sphereMat!.setValue(10.0, forKey: "scaleUpFactor")
            sphereMat!.setValue(0.2, forKey: "deformFactor")
            */
        }
        
        
        return lavaMaterials[lavaType]!
    }
    
    class func wandNode() -> SCNNode {
        let wandNode = SCNNode()
        wandNode.name = WAND_NODE_NAME
        
        // handle of the wand
        let cone = SCNCone(topRadius: HANDLE_TOP_RADIUS,
                           bottomRadius: HANDLE_BOTTOM_RADIUS,
                           height: HANDLE_LENGTH)
        cone.heightSegmentCount = 12
        cone.materials = coneMaterials()
        let coneNode = SCNNode(geometry: cone)
        wandNode.addChildNode(coneNode)
        
        // tip/sphere of the wand
        let sphere = SCNSphere(radius: TIP_WITH_DISPLACEMENT_RADIUS)
        sphere.materials = [sphereMaterial(lavaType: .lavaBall)]
        let sphereNode = SCNNode(geometry: sphere)
        //sphereNode.eulerAngles = SCNVector3(0,90.0.degreesToRadians,0)
        sphereNode.position = SCNVector3(0,HANDLE_LENGTH * 0.5 + TIP_RADIUS * 0.75,0)
        sphereNode.name = TIP_NODE_NAME
        wandNode.addChildNode(sphereNode)
        
        return wandNode
    }
    
    class func node() -> SCNNode {
        let node = SCNNode()
        
        let wandNode = self.wandNode()
        wandNode.eulerAngles = SCNVector3(0,0,45.0.degreesToRadians)
        wandNode.position = SCNVector3(0,0.3,0)
        node.addChildNode(wandNode)
        
        let physicsGeometry = SCNBox(width: SIZE, height: SIZE, length: SIZE, chamferRadius: 0)
        node.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                          shape: SCNPhysicsShape(geometry: physicsGeometry, options: nil))
        node.physicsBody!.categoryBitMask = CollisionTypes.pickup.rawValue
        node.physicsBody!.collisionBitMask = 0
        node.physicsBody!.contactTestBitMask = CollisionTypes.player.rawValue
        
        let moveUpAction = SCNAction.moveBy(x: 0, y: 0.1, z: 0, duration: 0.3)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -0.1, z: 0, duration: 0.3)
        let waitAction = SCNAction.wait(duration: 1.5)
        let sequence = SCNAction.sequence([moveUpAction, moveDownAction, moveUpAction, moveDownAction, waitAction])
        node.runAction(SCNAction.repeatForever(sequence))
        
        return node
    }
}
