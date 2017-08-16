//
//  RotationTrack.swift
//  AR-SMB
//
//  Created by Bjarne Lundgren on 15/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

enum RotationTrack {
    case isReady
    case started(position:SCNVector3, screenCenter:CGPoint)
    case isDone
}
