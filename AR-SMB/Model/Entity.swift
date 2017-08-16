//
//  Entity.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

enum BlockType {
    case solid
    case powerUp(powerUp: PowerUp?, path: [(toMove:Int, altitude:CGFloat)])
    case usedPowerUp
    case destructible
}

typealias CollisionBounds = (lower:SCNVector3, upper:SCNVector3)

enum Entity {
    case hole
    case block(type:BlockType)
    case tube(height:CGFloat)
    case coin
    case flagPole(isFlagUp:Bool)
    case monster(isAlive:Bool, path:[SCNVector3])
    case pickup(pickup: Pickup)
}
