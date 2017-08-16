//
//  Tube.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 02/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class Tube {
    static let TUBE_RADIUS:CGFloat = 0.48
    
    static let TUBE_TOP_RADIUS:CGFloat = 0.55
    static let TUBE_TOP_HEIGHT:CGFloat = 0.25
    
    class func tubeMaterials(height:CGFloat) -> [SCNMaterial] {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/tube/4323914169_f9d4f1222d_o.jpg")
        mat.normal.contents = UIImage(named: "art.scnassets/tube/tube2_normal.png")
        
        // this specular map has no effect whatsoever :-(
        mat.specular.contents = UIImage(named: "art.scnassets/tube/tube2_specular2.png")!
        
        let circumference = CGFloat.pi * TUBE_RADIUS * 2.0
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(floor(circumference / 0.5)), Float(height) / 0.5, 0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        mat.normal.contentsTransform = mat.diffuse.contentsTransform
        mat.normal.wrapS = .repeat
        mat.normal.wrapT = .repeat
        
        mat.specular.contentsTransform = mat.diffuse.contentsTransform
        mat.specular.wrapS = .repeat
        mat.specular.wrapT = .repeat
        mat.shininess = 50.0
        
        return [mat]
    }
    
    class func tubeTopMaterials() -> [SCNMaterial] {
        let mat  = SCNMaterial()
        mat.diffuse.contents = UIImage(named: "art.scnassets/tube/1ef815a3156e5ca9649eb743e4342367--seamless-texture-metal-texture.jpg")
        mat.specular.contents = UIColor.white
        
        let circumference = CGFloat.pi * TUBE_TOP_RADIUS * 2.0
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(floor(circumference / TUBE_TOP_HEIGHT)), 1, 0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        mat.normal.contentsTransform = mat.diffuse.contentsTransform
        mat.normal.wrapS = .repeat
        mat.normal.wrapT = .repeat
        
        let edgeMat = SCNMaterial()
        edgeMat.diffuse.contents = UIImage(named: "art.scnassets/tube/1ef815a3156e5ca9649eb743e4342367--seamless-texture-metal-texture.jpg")
        edgeMat.specular.contents = UIColor.white
        
        edgeMat.normal.contentsTransform = SCNMatrix4MakeScale(8, 8, 0)
        edgeMat.diffuse.wrapS = .repeat
        edgeMat.diffuse.wrapT = .repeat
        
        edgeMat.normal.contentsTransform = SCNMatrix4MakeScale(8, 8, 0)
        edgeMat.normal.wrapS = .repeat
        edgeMat.normal.wrapT = .repeat
        
        return [mat, edgeMat, edgeMat]
    }
    
    class func node(height:CGFloat) -> SCNNode {
        let node = SCNNode()
        
        // tube itself
        let tube = SCNCylinder(radius: TUBE_RADIUS,
                               height: height)
        tube.materials = tubeMaterials(height: height)
        let tubeNode = SCNNode(geometry: tube)
        tubeNode.position = SCNVector3(0, height * 0.5, 0)
        node.addChildNode(tubeNode)
        
        // the "top" of the tube
        let tubeTop = SCNCylinder(radius: TUBE_TOP_RADIUS,
                               height: TUBE_TOP_HEIGHT)
        tubeTop.materials = tubeTopMaterials()
        let tubeTopNode = SCNNode(geometry: tubeTop)
        tubeTopNode.position = SCNVector3(0, height + TUBE_TOP_HEIGHT * 0.5, 0)
        node.addChildNode(tubeTopNode)
        

        tubeNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                          shape: nil)
        tubeNode.physicsBody!.categoryBitMask = CollisionTypes.solid.rawValue
        tubeNode.physicsBody!.collisionBitMask = CollisionTypes.fireball.rawValue
        tubeNode.physicsBody!.contactTestBitMask = 0
        
        tubeTopNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                              shape: nil)
        tubeTopNode.physicsBody!.categoryBitMask = CollisionTypes.solid.rawValue
        tubeTopNode.physicsBody!.collisionBitMask = CollisionTypes.fireball.rawValue
        tubeTopNode.physicsBody!.contactTestBitMask = 0
    
        return node
    }
    
}
