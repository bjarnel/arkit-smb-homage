//
//  CollisionTypes.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 03/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation

enum CollisionTypes: Int {
    case none = 0
    case player = 1
    case coin = 2
    case box = 4
    case monster = 8
    case flagPoleBase = 16
    case pickup = 32
    case fireball = 64
    // any of solid nature, should reflect projectiles
    case solid = 128
}
