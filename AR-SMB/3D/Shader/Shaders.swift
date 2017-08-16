//
//  LoadShader.swift
//  AR-SMB
//
//  Created by Bjarne Lundgren on 11/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation

class Shaders {
    static let shared = Shaders()
    
    
    let lava_deform:String
    let emission:String
    let bubble:String
    let geo_ripple:String
    let geo_strange:String
    
    let types:[String:String] = [
        "geo_strange":"shader"
    ]
    
    init() {
        
        lava_deform = try! String(contentsOfFile: Bundle.main.path(forResource: "lava_deform", ofType: "shader")!)
        emission = try! String(contentsOfFile: Bundle.main.path(forResource: "emission", ofType: "shader")!)
        bubble = try! String(contentsOfFile: Bundle.main.path(forResource: "bubble", ofType: "shader")!)
        geo_ripple = try! String(contentsOfFile: Bundle.main.path(forResource: "geo_ripple", ofType: "shader")!)
        geo_strange = try! String(contentsOfFile: Bundle.main.path(forResource: "geo_strange", ofType: types["geo_strange"] ?? "shader")!)
    }
}
