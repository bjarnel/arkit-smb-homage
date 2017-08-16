//
//  Levels.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

typealias LevelEntity = (entity: Entity, position: SCNVector3)

class Levels {
    class func world11() -> [LevelEntity] {
        return [
            // start out like the original, first a powerUp block
            LevelEntity(entity: .block(type: .powerUp(powerUp: .coin,
                                                    path: [(toMove:1,
                                                            altitude:Block.BLOCK_OFFSET + Block.BLOCK_SIZE)])),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,0)),
            // moonsters
            LevelEntity(entity: .monster(isAlive: true,
                                        path: [SCNVector3(0,0,3), SCNVector3(0,0,11)]),
                        position: SCNVector3(0,0,11)),
            // coins
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,2)),
            /*LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,3)),*/
            // then 3 meters later, block,powerup,block,powerup,block + powerup above it
            LevelEntity(entity: .block(type: .destructible),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,4)),
            LevelEntity(entity: .block(type: .powerUp(powerUp: .wand,
                                                    path: [(toMove:4,
                                                            altitude:Block.BLOCK_OFFSET + Block.BLOCK_SIZE)])),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,5)),
            LevelEntity(entity: .block(type: .destructible),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,6)),
                    // above the others!
                    LevelEntity(entity: .block(type: .powerUp(powerUp: nil,
                                                            path: [(toMove:1,
                                                                    altitude:Block.BLOCK_OFFSET),
                                                                   (toMove:3,
                                                                    altitude:Block.BLOCK_OFFSET + Block.BLOCK_SIZE)])),
                                position: SCNVector3(0,Block.BLOCK_OFFSET * 2 + Block.BLOCK_SIZE,6)),
            LevelEntity(entity: .block(type: .powerUp(powerUp: .life,
                                                    path: [(toMove:2,
                                                            altitude:Block.BLOCK_OFFSET + Block.BLOCK_SIZE)])),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,7)),
            LevelEntity(entity: .block(type: .destructible),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,8)),
            // then some tubes of increasing height
            LevelEntity(entity: .tube(height:0.5),
                        position: SCNVector3(0,0,12)),
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,13)),
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET * 2,14)),
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET * 3,15)),
            LevelEntity(entity: .tube(height:1.0),
                        position: SCNVector3(0,0,16)),
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,18)),
            LevelEntity(entity: .tube(height:1.5),
                        position: SCNVector3(0,0,20)),
            // monsters
            LevelEntity(entity: .monster(isAlive: true,
                                        path: [SCNVector3(0,0,23), SCNVector3(0,0,21)]),
                        position: SCNVector3(0,0,21)),
            /*LevelEntity(entity: .monster(isAlive: true,
                                        path: [SCNVector3(0,0,21), SCNVector3(0,0,23)]),
                        position: SCNVector3(0,0,23)),*/
            // hole
            LevelEntity(entity: .hole,
                        position: SCNVector3(0,-2,24)),
            // coins
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,25)),
            /*LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,26)),
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,27)),
            */
            
            // misc
            LevelEntity(entity: .block(type: .destructible),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,25)),
            LevelEntity(entity: .block(type: .powerUp(powerUp: nil,
                                                      path: [(toMove:2,
                                                              altitude:Block.BLOCK_OFFSET + Block.BLOCK_SIZE)])),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,26)),
            LevelEntity(entity: .block(type: .destructible),
                        position: SCNVector3(0,Block.BLOCK_OFFSET,27)),
                LevelEntity(entity: .block(type: .destructible),
                            position: SCNVector3(0,Block.BLOCK_OFFSET * 2 + Block.BLOCK_SIZE,27)),
                /*LevelEntity(entity: .block(type: .destructible),
                            position: SCNVector3(0,Block.BLOCK_OFFSET * 2 + Block.BLOCK_SIZE,28)),
                LevelEntity(entity: .block(type: .destructible),
                            position: SCNVector3(0,Block.BLOCK_OFFSET * 2 + Block.BLOCK_SIZE,29)),*/
                
            // another hole
            /*LevelEntity(entity: .hole,
                        position: SCNVector3(0,-2,28)),*/
            // monsters
            LevelEntity(entity: .monster(isAlive: true,
                                        path: [SCNVector3(0,0,26), SCNVector3(0,0,27)]),
                        position: SCNVector3(0,0,27)),
            // pile of boxes
            LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,0,28)),
            LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,0,29)),LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,Block.BLOCK_SIZE,29)),
            LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,0,30)),LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,Block.BLOCK_SIZE,30)),LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,Block.BLOCK_SIZE * 2,30)),
            // hole
            LevelEntity(entity: .hole,
                        position: SCNVector3(0,-2,31)),
            // pile of boxes
            LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,0,32)),LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,Block.BLOCK_SIZE,32)),LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,Block.BLOCK_SIZE * 2,32)),
            LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,0,33)),LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,Block.BLOCK_SIZE,33)),
            LevelEntity(entity: .block(type: .solid), position: SCNVector3(0,0,34)),
            // now lets just plug down the flag for now
            LevelEntity(entity: .flagPole(isFlagUp: true),
                        position: SCNVector3(0,0,37)),
            
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(1,Coin.COIN_OFFSET,37)),
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(-1,Coin.COIN_OFFSET,37)),
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(1,Coin.COIN_OFFSET,38)),
            
            LevelEntity(entity: .coin,
                        position: SCNVector3(0,Coin.COIN_OFFSET,38)),
            LevelEntity(entity: .coin,
                        position: SCNVector3(-1,Coin.COIN_OFFSET,38)),
        ]
    }
    
    class func monsters() -> [LevelEntity] {
        return [LevelEntity(entity: .monster(isAlive: true, path: []),
                            position: SCNVector3(0,0,0)),
                LevelEntity(entity: .monster(isAlive: true, path: [SCNVector3(2,0,1), SCNVector3(-2,0,1)]),
                            position: SCNVector3(0,0,1)),
                LevelEntity(entity: .coin,
                            position: SCNVector3(0,Coin.COIN_OFFSET,2))]
    }
    
    class func flagPole() -> [LevelEntity] {
        return [LevelEntity(entity: .flagPole(isFlagUp: true),
                            position: SCNVector3(0,0,0))]
    }
    
    class func oneHole() -> [LevelEntity] {
        return [LevelEntity(entity: .hole,
                            position: SCNVector3(0,-2,0)),
                LevelEntity(entity: .hole,
                            position: SCNVector3(0,-2,1.2)),
                LevelEntity(entity: .hole,
                            position: SCNVector3(0,-2,2.4)),
                LevelEntity(entity: .hole,
                            position: SCNVector3(0,-2,3.6))]
    }
    
    class func someCoins() -> [LevelEntity] {
        return [LevelEntity(entity: .coin,
                            position: SCNVector3(0,Coin.COIN_OFFSET,0)),
                LevelEntity(entity: .coin,
                            position: SCNVector3(0,Coin.COIN_OFFSET * 2,1.2)),
                LevelEntity(entity: .coin,
                            position: SCNVector3(0,Coin.COIN_OFFSET * 3,2.6))]
    }
    
    class func someTubes() -> [LevelEntity] {
        return [LevelEntity(entity: .tube(height:0.5),
                            position: SCNVector3(0,0,0)),
                LevelEntity(entity: .tube(height:1.0),
                            position: SCNVector3(0,0,1.2)),
                LevelEntity(entity: .tube(height:1.5),
                            position: SCNVector3(0,0,2.6))]
    }
    
    class func powerUps() -> [LevelEntity] {
        return [LevelEntity(entity: .monster(isAlive: true, path: []),
                            position: SCNVector3(0,0,1)),
                LevelEntity(entity: .monster(isAlive: true, path: []),
                            position: SCNVector3(1,0,2)),
                LevelEntity(entity: .monster(isAlive: true, path: []),
                            position: SCNVector3(1,0,2)),
                LevelEntity(entity: .tube(height:1.5),
                           position: SCNVector3(0,0,2)),
                LevelEntity(entity: .block(type: .solid),
                            position: SCNVector3(-1,0,1)),
                LevelEntity(entity: .block(type: .solid),
                            position: SCNVector3(1,0,1)),
                // (toMove:Int, altitude:CGFloat)
                //LevelEntity(entity: .box(type: .powerUp(powerUp: .fireball, path: [SCNVector3(0,Box.BOX_OFFSET + Wand.SIZE * 0.5,Box.BOX_SIZE * 0.5 + Wand.SIZE * 0.5), SCNVector3(0,Wand.SIZE * 0.5,Box.BOX_SIZE * 0.5 + Wand.SIZE * 0.5)])),
            LevelEntity(entity: .block(type: .powerUp(powerUp: .wand, path: [])),
                            position: SCNVector3(0,Block.BLOCK_OFFSET,0))]
    }
    
    class func someBoxes() -> [LevelEntity] {
        return [LevelEntity(entity: .block(type: .powerUp(powerUp: nil, path: [])),
                            position: SCNVector3(0,Block.BLOCK_OFFSET,1)),
                LevelEntity(entity: .block(type: .destructible),
                            position: SCNVector3(0,Block.BLOCK_OFFSET,2)),
                LevelEntity(entity: .block(type: .solid),
                            position: SCNVector3(0,Block.BLOCK_OFFSET,3)),
                LevelEntity(entity: .block(type: .usedPowerUp),
                            position: SCNVector3(0,Block.BLOCK_OFFSET,4)),
        
        ]
        
    }
    
}
