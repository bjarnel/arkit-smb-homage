//
//  Anim2D.swift
//  SuperMarioAR
//
//  Created by Bjarne Møller Lundgren on 04/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SpriteKit

class Anim2D {
    class func granted(pickup:Pickup, scene:SKScene) {
        let label = SKLabelNode(fontNamed: "Emulogic")
        label.fontSize = 60
        label.fontColor = UIColor.blue
        
        switch pickup {
        case .fireballPowerUp:
            label.text = "FIREBALLS!"
        }
        
        label.position = CGPoint(x: scene.size.width * 0.5, y: 0)
        label.yScale = 10
        label.horizontalAlignmentMode = .left
        scene.addChild(label)
        
        let colorRed = SKAction.colorize(with: .red, colorBlendFactor: 1, duration: 0.05)
        let colorGreen = SKAction.colorize(with: .green, colorBlendFactor: 1, duration: 0.05)
        let colorBlue = SKAction.colorize(with: .blue, colorBlendFactor: 1, duration: 0.05)
        let colorSequence = SKAction.sequence([colorRed, colorGreen, colorBlue])
        label.run(SKAction.repeatForever(colorSequence))
        
        let scaleDownAction = SKAction.scaleY(to: 2, duration: 1.5)
        let moveAction = SKAction.move(to: CGPoint(x: scene.size.width * -0.5, y: -100), duration: 0.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        label.run(moveAction) {
            label.run(scaleDownAction) {
                label.run(fadeOutAction) {
                    label.removeFromParent()
                }
            }
        }
    }
    
    class func gainedLife(scene:SKScene) {
        let label = SKLabelNode(fontNamed: "Emulogic")
        label.fontSize = 72
        label.fontColor = UIColor.green
        label.position = CGPoint(x: 0,
                                 y: 0)
        label.horizontalAlignmentMode = .center
        label.text = "+1 LIFE"
        label.yScale = 0
        scene.addChild(label)
        
        let scaleUpAction = SKAction.scaleY(to: 1, duration: 0.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
        label.run(scaleUpAction) {
            label.run(fadeOutAction) {
                label.removeFromParent()
            }
        }
    }
    
    class func lostLife(scene:SKScene) {
        let label = SKLabelNode(fontNamed: "Emulogic")
        label.fontSize = 72
        label.fontColor = UIColor.red
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0,
                                 y: 0)
        label.text = "-1 LIFE"
        label.yScale = 0
        scene.addChild(label)
        
        let scaleUpAction = SKAction.scaleY(to: 1, duration: 0.5)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
        label.run(scaleUpAction) {
            label.run(fadeOutAction) {
                label.removeFromParent()
            }
        }
    }
    
    class func completed(scene:SKScene) {
        let label = SKLabelNode(fontNamed: "Emulogic")
        label.fontSize = 72
        label.fontColor = UIColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0,
                                 y: 0)
        label.text = "LEVEL\nCOMPLETE!"
        label.numberOfLines = 2
        label.yScale = 0
        scene.addChild(label)
        
        let scaleUpAction = SKAction.scaleY(to: 1, duration: 0.5)
        label.run(scaleUpAction)
    }
    
    class func score(_ pts:Int, scene:SKScene) {
        let label = SKLabelNode(fontNamed: "Emulogic")
        label.fontSize = 72
        label.fontColor = UIColor.white
        label.alpha = 0
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0,
                                 y: 200)
        label.text = "\(pts)"
        let fadeInAction = SKAction.fadeIn(withDuration: 0.2)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
        let moveDownAction = SKAction.move(by: CGVector(dx: 0, dy: -400),
                                           duration: 1)
        let waitAction = SKAction.wait(forDuration: 0.8)
        scene.addChild(label)
        label.run(fadeInAction)
        label.run(moveDownAction)
        label.run(waitAction) {
            label.run(fadeOutAction) {
                label.removeFromParent()
            }
        }
    }
}
