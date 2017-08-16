//
//  Sound.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 04/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

private var sources = [Sound:SCNAudioSource]()

enum Sound:String {
    case oneUp = "368688__vortencho12__loadsound.wav"
    case breakBlock = "387862__runningmind__explosion-enemy.wav"
    case bump = "277220__thedweebman__8-bit-wrong-item.wav"
    case coin = "277215__thedweebman__8-bit-coin.wav"
    case fireball = "159377__greenhourglass__pongblip1.wav"
    case flagPole = "213704__taira-komori__stair01.mp3"
    case jump = "277219__thedweebman__8-bit-jump-2.wav"
    case powerUpAppears = "346116__lulyc__retro-game-heal-sound.wav"
    case powerUp = "277214__thedweebman__8-bit-powerup-get-something-big.wav"
    case stomp = "167338__willy-ineedthatapp-com__pup-fat.mp3"
    case takeDamage = "277213__thedweebman__8-bit-hit.wav"
    
    var source:SCNAudioSource {
        if sources[self] == nil {
            let source = SCNAudioSource(named: self.rawValue)!
            source.loops = false
            source.isPositional = false
            source.load()
            sources[self] = source
        }
        return sources[self]!
    }
}
