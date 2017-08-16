//
//  Flag.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 02/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class FlagPole {
    static let FLAG_BASE_RADIUS:CGFloat = 0.25
    static let FLAG_BASE_HEIGHT:CGFloat = 0.25
    
    static let FLAG_POLE_RADIUS:CGFloat = 0.05
    static let FLAG_POLE_HEIGHT:CGFloat = 5 - FLAG_BASE_HEIGHT
    
    static let FLAG_SIZE:CGFloat = 0.8
    static let FLAG_NODE_NAME = "flag"
    
    class func baseMaterials() -> [SCNMaterial] {
        let mat  = SCNMaterial()
        
        mat.diffuse.contents = UIImage(named: "art.scnassets/flagpole/flagbase.png")
        mat.normal.contents = UIImage(named: "art.scnassets/flagpole/flagbase_normal.png")
        mat.specular.contents = UIColor.white
        
        let circumference = CGFloat.pi * FLAG_BASE_RADIUS * 2.0
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(floor(circumference / FLAG_BASE_HEIGHT)), 1, 0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        mat.normal.contentsTransform = mat.diffuse.contentsTransform
        mat.normal.wrapS = .repeat
        mat.normal.wrapT = .repeat
        
        let edgeMat  = SCNMaterial()
        
        edgeMat.diffuse.contents = UIImage(named: "art.scnassets/flagpole/flagbase.png")
        edgeMat.normal.contents = UIImage(named: "art.scnassets/flagpole/flagbase_normal.png")
        
        edgeMat.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 0)
        edgeMat.diffuse.wrapS = .repeat
        edgeMat.diffuse.wrapT = .repeat
        
        edgeMat.normal.contentsTransform = edgeMat.diffuse.contentsTransform
        edgeMat.normal.wrapS = .repeat
        edgeMat.normal.wrapT = .repeat
        
        return [mat, edgeMat, edgeMat]
    }
    
    class func poleMaterial() -> SCNMaterial {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/flagpole/pole.png")
        mat.normal.contents = UIImage(named: "art.scnassets/flagpole/pole_normal.png")
        
        let circumference = CGFloat.pi * FLAG_POLE_RADIUS * 2.0
        // approx 0.314...
        // / 4.75 -> 0.0661 -> floor -> 0
        
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(1, Float(FLAG_POLE_HEIGHT / circumference), 0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        mat.normal.contentsTransform = mat.diffuse.contentsTransform
        mat.normal.wrapS = .repeat
        mat.normal.wrapT = .repeat
        
        return mat
    }
    
    class func flagMaterial() -> SCNMaterial {
        let flagImage = UIImage(named: "art.scnassets/flagpole/arkit_white.png")!
        
        let mat  = SCNMaterial()
        mat.diffuse.contents = ImageUtil.flipImageLeftRight(flagImage)
        mat.isDoubleSided = true
        // this is a naive flag ripple! it actually streches the flag!
        // to calculate the right width (x) of the flag when bended is a completely
        // different manner!
        mat.shaderModifiers = [SCNShaderModifierEntryPoint.geometry:  """
            float x = (_geometry.position.x + 0.4) / 0.8;
            _geometry.position.z += 0.1 * sin(u_time + 5.0 * x) * x;
            """]
        
        
        return mat
    }
    
    class func node() -> SCNNode {
        let node = SCNNode()
        
        // base of flag
        let base = SCNCylinder(radius: FLAG_BASE_RADIUS,
                               height: FLAG_BASE_HEIGHT)
        base.materials = baseMaterials()
        let baseNode = SCNNode(geometry: base)
        baseNode.position = SCNVector3(0, FLAG_BASE_HEIGHT * 0.5, 0)
        
        baseNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                          shape: nil)
        baseNode.physicsBody!.categoryBitMask = CollisionTypes.flagPoleBase.rawValue
        baseNode.physicsBody!.collisionBitMask = 0
        baseNode.physicsBody!.contactTestBitMask = CollisionTypes.player.rawValue
        
        node.addChildNode(baseNode)
        
        // pole
        let pole = SCNCylinder(radius: FLAG_POLE_RADIUS,
                               height: FLAG_POLE_HEIGHT)
        pole.materials = [poleMaterial()]
        let poleNode = SCNNode(geometry: pole)
        poleNode.position = SCNVector3(0, FLAG_POLE_HEIGHT * 0.5 + FLAG_BASE_HEIGHT, 0)
        node.addChildNode(poleNode)
        
        // flag
        let flag = SCNPlane(width: FLAG_SIZE,
                            height: FLAG_SIZE)
        flag.widthSegmentCount = 50
        flag.heightSegmentCount = 50
        flag.materials = [flagMaterial()]
        
        let flagNode = SCNNode(geometry: flag)
        flagNode.position = SCNVector3(FLAG_SIZE * 0.5 + FLAG_POLE_RADIUS,
                                       FLAG_POLE_HEIGHT + FLAG_BASE_HEIGHT - FLAG_SIZE * 0.5,
                                       0)
        flagNode.name = FLAG_NODE_NAME
        node.addChildNode(flagNode)
        
        return node
    }
}
