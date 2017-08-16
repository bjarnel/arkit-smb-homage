//
//  Light.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 07/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class Light {
    class func spotNode(center:SCNVector3) -> SCNNode {
        let light = SCNLight()
        light.type = .spot
        light.castsShadow = true
        light.spotInnerAngle = 70
        light.spotOuterAngle = 80
        
        light.shadowRadius = 200
        light.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        light.shadowMode = .deferred
        
        // this is a big impact on performance, you might want it play around with this, and/or add more light
        // and reduce this.
        light.shadowMapSize = CGSize(width: 4096, height: 4096)
        
        light.zNear = CGFloat(center.z * 0.5)
        light.zFar = CGFloat(center.z * 3)
        
        light.maximumShadowDistance = light.zFar
 
        let node = SCNNode()
        node.light = light
        node.position = SCNVector3(center.z * -0.5, center.z * 2, center.z)
        node.look(at: center)
        
        return node
    }
    
    class func ambient() -> SCNLight {
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        // lumens, 1000 is default, prone for tweaking
        ambientLight.intensity = 300
        return ambientLight
    }
}
