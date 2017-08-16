//
//  Level.swift
//  SuperMarioAR
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

typealias LevelInfo = (container:SCNNode, entities:[String:Entity], nodes:[SCNNode:String])

class Level {
    
    class func make(from entities:[LevelEntity]) -> LevelInfo {
        let container = SCNNode()
        container.addChildNode(Floor.node())
        
        var rentities = [String:Entity]()
        var nodes = [SCNNode:String]()
        
        for entity in entities {
            let node:SCNNode
            
            switch entity.entity {
            case .hole:
                node = Hole.node()
            case .block(let type):
                node = Block.node(boxType: type)
            case .tube(let height):
                node = Tube.node(height: height)
            case .coin:
                node = Coin.node()
                
                
            case .flagPole:
                node = FlagPole.node()
            case .monster(_, let path):
                node = Monster.node()
                
                if !path.isEmpty {
                    var currentPosition = entity.position
                    var actions = [SCNAction]()
                    for toPosition in path {
                        let orientationAngle = atan2(toPosition.z - currentPosition.z,
                                                     toPosition.x - currentPosition.x).radiansToDegrees
                        let rotateAction = SCNAction.rotateTo(x: 0,
                                                              y: CGFloat((-orientationAngle + 90).degreesToRadians),
                                                              z: 0,
                                                              duration: 0.1)
                        actions.append(rotateAction)
                        
                        let distance = currentPosition.distance(vector: toPosition)
                        let duration = TimeInterval(distance) * TimeInterval(Monster.METERS_PER_SECOND)
                        actions.append(SCNAction.move(to: toPosition, duration: duration))
                        currentPosition = toPosition
                    }
                    let moveActionsSequence = SCNAction.sequence(actions)
                    let repeatedAction = SCNAction.repeatForever(moveActionsSequence)
                    
                    node.runAction(repeatedAction)
                }
            case .pickup:
                continue
                
            }
            
            node.position = entity.position
            container.addChildNode(node)
            
            let id = UUID().uuidString
            rentities[id] = entity.entity
            nodes[node] = id
        }
        
        return (container: container,
                entities: rentities,
                nodes: nodes)
    }
}
