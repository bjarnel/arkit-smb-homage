//
//  Coin.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 02/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

class Coin {
    static let COIN_RADIUS:CGFloat = 0.25
    static let COIN_THICKNESS:CGFloat = 0.05
    static let COIN_OFFSET:CGFloat = 0.8
    
    private static var coin:SCNGeometry?
    
    class func coinMaterials() -> [SCNMaterial] {
        // https://developer.apple.com/documentation/scenekit/scnmaterial/1462520-reflective
        // (or Right, Left, Top, Bottom, Near, Far).
        /*
        let eMap = [
            UIImage(named: "art.scnassets/coin/r_right.jpg")!,
            UIImage(named: "art.scnassets/coin/r_left.jpg")!,
            UIImage(named: "art.scnassets/coin/r_up.jpg")!,
            UIImage(named: "art.scnassets/coin/r_down.jpg")!,
            UIImage(named: "art.scnassets/coin/r_near.jpg")!,
            UIImage(named: "art.scnassets/coin/r_far.jpg")!
        ]
 */
        
        let edgeMaterial = SCNMaterial()
        edgeMaterial.shininess = 50.0
        edgeMaterial.reflective.contents = UIImage(named: "art.scnassets/coin/coin_reflect.png")
        edgeMaterial.diffuse.contents = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
        edgeMaterial.specular.contents = UIColor.white
        edgeMaterial.normal.contents = UIImage(named: "art.scnassets/coin/coin_edge_normal.png")!
        edgeMaterial.normal.contentsTransform = SCNMatrix4MakeScale(157, 1, 0)
        edgeMaterial.normal.wrapS = .repeat
        edgeMaterial.normal.wrapT = .repeat
        
        let surfaceMaterial = SCNMaterial()
        surfaceMaterial.shininess = 50.0
        surfaceMaterial.reflective.contents = UIImage(named: "art.scnassets/coin/coin_reflect.png")
        surfaceMaterial.diffuse.contents = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
        surfaceMaterial.specular.contents = UIColor.white
        surfaceMaterial.normal.contents = UIImage(named: "art.scnassets/coin/coin_normal.png")!
        
        return [edgeMaterial, surfaceMaterial, surfaceMaterial]
    }
    
    class func node() -> SCNNode {
        let node = SCNNode()
        
        // re-use geometry
        if coin == nil {
            coin = SCNCylinder(radius: COIN_RADIUS,
                               height: COIN_THICKNESS)
            coin!.materials = coinMaterials()
        }
        let coinNode = SCNNode(geometry: coin!)
        coinNode.eulerAngles = SCNVector3(0, 0, 90 * Float.pi / 180)
        
        coinNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic,
                                              shape: nil)
        
        // https://www.hackingwithswift.com/read/26/2/loading-a-level-categorybitmask-collisionbitmask-contacttestbitmask
        coinNode.physicsBody!.categoryBitMask = CollisionTypes.coin.rawValue
        coinNode.physicsBody!.collisionBitMask = 0
        coinNode.physicsBody!.contactTestBitMask = CollisionTypes.player.rawValue
        //coinNode.castsShadow = false
        
        node.addChildNode(coinNode)
        
        let rotateAction = SCNAction.rotateBy(x: 0,
                                              y: CGFloat(90.0.degreesToRadians),
                                              z: 0,
                                              duration: 5)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        node.runAction(repeatAction)
        
        
        return node
    }
}
