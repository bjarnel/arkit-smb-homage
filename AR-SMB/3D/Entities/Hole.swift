//
//  Hole.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

private let RENDERING_ORDER_INSIDE = 0
private let RENDERING_ORDER_MASK = -10

class Hole {
    // this is the width on the Z axis!
    static let HOLE_WIDTH:CGFloat = 1
    
    // this is the width on the X axis!
    static let HOLE_DEPTH:CGFloat = 2
    
    // how deep the hole!
    static let HOLE_HEIGHT:CGFloat = 2
    
    private static var _baseSideMaterial:SCNMaterial?
    private static var _maskMaterial:SCNMaterial?
    
    private class func baseSideMaterial() -> SCNMaterial {
        if _baseSideMaterial == nil {
            _baseSideMaterial = SCNMaterial()
            _baseSideMaterial!.diffuse.contents = UIImage(named: "art.scnassets/hole/stonewall_big_baked.png")
            _baseSideMaterial!.emission.contents = UIImage(named: "art.scnassets/hole/stonewall_big_emission.png")
            _baseSideMaterial!.normal.contents = UIImage(named: "art.scnassets/hole/stonewall_big_normal.png")
            _baseSideMaterial!.displacement.contents = UIImage(named: "art.scnassets/hole/stonewall_big_displacement")
            
            // we need to tweak this, as well the the actualy side/emission texture used to make this much nicer...
            _baseSideMaterial!.shaderModifiers = [
                SCNShaderModifierEntryPoint.surface: """
                float factor = sin(u_time);
                
                float r = clamp(_surface.emission[0] + _surface.emission[0] * factor, 0.0, 1.0);
                float g = clamp(_surface.emission[1] + _surface.emission[1] * factor, 0.0, 1.0);
                float b = clamp(_surface.emission[2] + _surface.emission[2] * factor, 0.0, 1.0);
                float a = _surface.emission[3];
                
                _surface.emission = vec4(r, g, b, a);
                """
            ]
        }
        return _baseSideMaterial!
    }
    
    class func sideMaterial() -> SCNMaterial {
        let mat  = baseSideMaterial()
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 1, 0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        return mat
    }
    
    class func endMaterial() -> SCNMaterial {
        let mat = baseSideMaterial()
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(1, 1, 0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        return mat
    }
    
    class func bottomMaterial() -> SCNMaterial {
        // this matches exactly what I want to do here...
        // https://stackoverflow.com/questions/44920519/repeating-a-texture-over-a-plane-in-scenekit
        // except the scaling was wrong..
        // re-use the fireball 1:1 material!
        let mat = Wand.sphereMaterial(lavaType: .lavaPond)
        
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(2,  // two times across the width of the plane!?
                                                            1,  // one times across the height of the plane?!
                                                            0)
        mat.diffuse.wrapS = .repeat
        mat.diffuse.wrapT = .repeat
        
        mat.normal.contentsTransform = SCNMatrix4MakeScale(2, 1, 0)
        mat.normal.wrapS = .repeat
        mat.normal.wrapT = .repeat
        
        //TODO: THIS crashes the app... I am afraid we need a 2x1 displacement texture for lava..
        /*
        mat.displacement.contentsTransform = SCNMatrix4MakeScale(2, 1, 0)
        mat.displacement.wrapS = .repeat
        mat.displacement.wrapT = .repeat
        */
        mat.emission.contentsTransform = SCNMatrix4MakeScale(2, 1, 0)
        mat.emission.wrapS = .repeat
        mat.emission.wrapT = .repeat
        
        return mat
    }
    
    class func maskMaterial() -> SCNMaterial {
        if _maskMaterial == nil {
            _maskMaterial = SCNMaterial()
            _maskMaterial!.diffuse.contents = UIColor.green
            _maskMaterial!.transparency = 0.000001
        }
        return _maskMaterial!
    }
    
    private static var sideGeometry:SCNPlane?
    private static var endGeometry:SCNPlane?
    private static var bottomGeometry:SCNPlane?
    
    class func node() -> SCNNode {
        let node = SCNNode()
        
        // side walls, we're using displacement "mapping" (a completely UNDOCUMENTED new iOS 11 feature)
        // and a big number of polygons (for a plane)
        // so we NEED to do caching! Essentially we're caching all of our high polygon count geometry, so
        // each hole, if multiple in scene, will get rendered using the same geometry and be much more performant
        if sideGeometry ==  nil {
            sideGeometry = SCNPlane(width: HOLE_DEPTH,
                                    height: HOLE_HEIGHT)
            sideGeometry!.materials = [sideMaterial()]
            sideGeometry!.widthSegmentCount = 100
            sideGeometry!.heightSegmentCount = 100
        }
        
        let side1 = SCNNode(geometry: sideGeometry!)
        side1.eulerAngles = SCNVector3(0, 180 * Float.pi / 180, 0)
        side1.position = SCNVector3(0, 0.5 * HOLE_HEIGHT, 0.5 * HOLE_WIDTH)
        side1.renderingOrder = RENDERING_ORDER_INSIDE
        node.addChildNode(side1)
        
        let side2 = SCNNode(geometry: sideGeometry!)
        side2.position = SCNVector3(0, 0.5 * HOLE_HEIGHT, -0.5 * HOLE_WIDTH)
        side2.renderingOrder = RENDERING_ORDER_INSIDE
        node.addChildNode(side2)
        
        //side wall masks
        // https://developer.apple.com/documentation/scenekit/scngeometry
        // DO NOT copy and re-use sideGeometry - DO NOT NEED THE POLYGON COUNT!
        //let sideMaskGeometry = sideGeometry!.copy() as! SCNPlane
        let sideMaskGeometry = SCNPlane(width: HOLE_DEPTH,
                                        height: HOLE_HEIGHT)
        sideMaskGeometry.materials = [maskMaterial()]
        
        let side1Mask = SCNNode(geometry: sideMaskGeometry)
        side1Mask.position = SCNVector3(0, 0.5 * HOLE_HEIGHT, 0.5 * HOLE_WIDTH + 0.001)
        side1Mask.renderingOrder = RENDERING_ORDER_MASK
        node.addChildNode(side1Mask)
        
        let side2Mask = SCNNode(geometry: sideMaskGeometry)
        side2Mask.eulerAngles = SCNVector3(0, 180 * Float.pi / 180, 0)
        side2Mask.position = SCNVector3(0, 0.5 * HOLE_HEIGHT, -0.5 * HOLE_WIDTH - 0.001)
        side2Mask.renderingOrder = RENDERING_ORDER_MASK
        node.addChildNode(side2Mask)
        
        // end walls
        if endGeometry == nil {
            endGeometry = SCNPlane(width: HOLE_WIDTH,
                                   height: HOLE_HEIGHT)
            endGeometry!.materials = [endMaterial()]
            endGeometry!.widthSegmentCount = 50
            endGeometry!.heightSegmentCount = 100
        }
        
        let end1 = SCNNode(geometry: endGeometry!)
        end1.eulerAngles = SCNVector3(0, 90 * Float.pi / 180, 0)
        end1.position = SCNVector3(-0.5 * HOLE_DEPTH, 0.5 * HOLE_HEIGHT, 0)
        end1.renderingOrder = RENDERING_ORDER_INSIDE
        node.addChildNode(end1)
        
        let end2 = SCNNode(geometry: endGeometry!)
        end2.eulerAngles = SCNVector3(0, -90 * Float.pi / 180, 0)
        end2.position = SCNVector3(0.5 * HOLE_DEPTH, 0.5 * HOLE_HEIGHT, 0)
        end2.renderingOrder = RENDERING_ORDER_INSIDE
        node.addChildNode(end2)
        
        //end wall masks, DO NOT copy the high polygon inside geometry!
        let endMaskGeometry = SCNPlane(width: HOLE_WIDTH,
                                       height: HOLE_HEIGHT)
        endMaskGeometry.materials = [maskMaterial()]
        
        let end1Mask = SCNNode(geometry: endMaskGeometry)
        end1Mask.eulerAngles = SCNVector3(0, -90 * Float.pi / 180, 0)
        end1Mask.position = SCNVector3(-0.5 * HOLE_DEPTH  - 0.001, 0.5 * HOLE_HEIGHT, 0)
        end1Mask.renderingOrder = RENDERING_ORDER_MASK
        node.addChildNode(end1Mask)
        
        let end2Mask = SCNNode(geometry: endMaskGeometry)
        end2Mask.eulerAngles = SCNVector3(0, 90 * Float.pi / 180, 0)
        end2Mask.position = SCNVector3(0.5 * HOLE_DEPTH + 0.001, 0.5 * HOLE_HEIGHT, 0)
        end2Mask.renderingOrder = RENDERING_ORDER_MASK
        node.addChildNode(end2Mask)
     
        if bottomGeometry == nil {
            bottomGeometry = SCNPlane(width: HOLE_DEPTH,
                                      height: HOLE_WIDTH)
            bottomGeometry!.widthSegmentCount = 100
            bottomGeometry!.heightSegmentCount = 50
            bottomGeometry!.materials = [bottomMaterial()]
        }
        
        let bottom = SCNNode(geometry: bottomGeometry!)
        bottom.eulerAngles = SCNVector3(-90 * Float.pi / 180, 0, 0)
        bottom.renderingOrder = RENDERING_ORDER_INSIDE
        
        node.addChildNode(bottom)
        
        return node
    }
}
