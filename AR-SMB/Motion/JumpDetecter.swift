//
//  JumpDetecter.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import CoreMotion
import GLKit

// this stuff only really works if jumping up/down, not forward,
// the vector to check for would then be 1/2 forward and 1/2 up I guess?
//private let THRESHOLD_LIFT_OFF:Double = 1.2
//private let THRESHOLD_LAND:Double = 0.8
private let THRESHOLD_LIFT_OFF:Double = 0.8
private let THRESHOLD_LAND:Double = 0.8
//private let THRESHOLD_MIN_AIR_TIME:TimeInterval = 0.5
//private let THRESHOLD_MAX_AIR_TIME:TimeInterval = 1
private let THRESHOLD_MIN_AIR_TIME:TimeInterval = 1
private let THRESHOLD_MAX_AIR_TIME:TimeInterval = 2
private let THRESHOLD_MIN_PAUSE_TIME:TimeInterval = 0.5

final class JumpDetecter {
    private let motionMgr = CMMotionManager()
    
    private(set) var isInAir = false
    private var liftOffTime = Date()
    private var landTime = Date()
    
    private var timer:Timer?
    
    init() {
        motionMgr.accelerometerUpdateInterval = 1.0 / 60.0
        motionMgr.startDeviceMotionUpdates()
        
        
        self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                           repeats: true, block: motionDataUpdate)
        
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    
    // https://stackoverflow.com/questions/21097692/using-cmdevicemotion-and-cmattitude-to-isolate-vertical-or-horizontal-accelerati
    private func yAccel(_ newMotion:CMDeviceMotion) -> Double {
        
        //Quaternion Conjugation
        // "Conjugation"?
        let quaternion = newMotion.attitude.quaternion
        let original_quaternion = GLKQuaternionMake(Float(quaternion.x),
                                                    Float(quaternion.y),
                                                    Float(quaternion.z),
                                                    Float(quaternion.w))
        let conjugated_quaternion = GLKQuaternionConjugate(original_quaternion)
        
        //Rotation of Accelerometer vector with quanternion
        let acceleromationVector = GLKVector3Make(Float(newMotion.userAcceleration.x),
                                                  Float(newMotion.userAcceleration.y),
                                                  Float(newMotion.userAcceleration.z))
        
        let accelerometionVector_toReferenceFrame = GLKQuaternionRotateVector3(conjugated_quaternion, acceleromationVector)
        
        // always posivetive!!! WHY?
        return Double(sqrtf(powf(accelerometionVector_toReferenceFrame.x,2)+powf(accelerometionVector_toReferenceFrame.y,2)))
    }
    
    @objc func motionDataUpdate(_ timer:Timer) {
        if let data = motionMgr.deviceMotion {
            let y = yAccel(data)
            
            if !isInAir {
                if Date().timeIntervalSince(landTime) > THRESHOLD_MIN_PAUSE_TIME &&
                    y > THRESHOLD_LIFT_OFF {
                    isInAir = true
                    //jumpStateLabel.text = "IN AIR!!!!"
                    liftOffTime = Date()
                }
            } else {
                if ( Date().timeIntervalSince(liftOffTime) > THRESHOLD_MIN_AIR_TIME &&
                    y > THRESHOLD_LAND ) ||
                    Date().timeIntervalSince(liftOffTime) > THRESHOLD_MAX_AIR_TIME {
                    isInAir = false
                    //jumpStateLabel.text = "__landed__"
                    landTime = Date()
                }
            }
        }
    }
}
