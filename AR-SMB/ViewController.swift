//
//  ViewController.swift
//  AR-SMB
//
//  Created by Bjarne Lundgren on 01/08/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

private let LEVEL = Levels.world11()

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var rotationTrack = RotationTrack.isReady
    var isReadyToStart = false
    var isPlaying = false
    var playerNode:SCNNode?
    
    var playerState:PlayerState!
    
    // current level data..
    var level:LevelInfo?
    
    // motion
    var jumpDetecter:JumpDetecter?
    var wandIsRecharging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        // sceneView.showsStatistics = true
        sceneView.scene.physicsWorld.contactDelegate = self
        // sceneView.debugOptions = .showPhysicsShapes
        
        sceneView.overlaySKScene = SKScene(fileNamed: "HUD")
        sceneView.overlaySKScene?.isPaused = false
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(didTap)))
        
        jumpDetecter = JumpDetecter()
        
        generateLevel()
    }
    
    private func generateLevel() {
        let levelEntities = LEVEL
        var maxZ:Float = 0
        for entity in levelEntities {
            if entity.position.z > maxZ {
                maxZ = entity.position.z
            }
        }
        
        level = Level.make(from: levelEntities)
        level!.container.light = Light.ambient()
        level!.container.addChildNode( Light.spotNode(center: SCNVector3(0, 0, maxZ * 0.5)) )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = false
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func anyPlaneFrom(location:CGPoint) -> (SCNNode, SCNVector3, ARPlaneAnchor)? {
        let results = sceneView.hitTest(location,
                                        types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        
        guard results.count > 0,
            let anchor = results[0].anchor as? ARPlaneAnchor,
            let node = sceneView.node(for: anchor) else { return nil }
        
        return (node,
                SCNVector3Make(results[0].worldTransform.columns.3.x, results[0].worldTransform.columns.3.y, results[0].worldTransform.columns.3.z),
                anchor)
    }
    
    @objc func didTap(_ sender:UITapGestureRecognizer) {
        if case .started(_, _) = rotationTrack {
            rotationTrack = .isDone
            
            sceneView.scene.rootNode.childNode(withName: "trackNode1", recursively: false)?.removeFromParentNode()
            sceneView.scene.rootNode.childNode(withName: "trackNode2", recursively: false)?.removeFromParentNode()
            return
        }
        
        if isPlaying, playerState != nil,
            let pickup = playerState.pickup,
            case .fireballPowerUp = pickup,
            !wandIsRecharging {
            // spawn fireballs!
            //let pov = sceneView.pointOfView!
            let fireballNode = Fireball.node()
            //fireballNode.position =sceneView.scene.rootNode.convertPosition(pov.position,
            //                                                                            to: level!.container)
            //level!.container.addChildNode(fireballNode)
            sceneView.scene.rootNode.addChildNode(fireballNode)
            // we need camera direction vector
            // https://developer.apple.com/videos/play/wwdc2017/602/
            let currentFrame = sceneView.session.currentFrame!
            let n = SCNNode()
            sceneView.scene.rootNode.addChildNode(n)
            
            var closeTranslation = matrix_identity_float4x4
            closeTranslation.columns.3.z = -0.5
            
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.5
            
            n.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
            fireballNode.simdTransform = matrix_multiply(currentFrame.camera.transform, closeTranslation)
            // n.simdTransform = matrix_multiply(pov.simdTransform, translation)
            
            let direction = (n.position - fireballNode.position).normalized
            
            // fireball should come FROM THE TIP of the wand!
            if let wandNode = sceneView.pointOfView?.childNode(withName: Wand.WAND_NODE_NAME, recursively: false),
                let tipNode = wandNode.childNode(withName: Wand.TIP_NODE_NAME, recursively: false) {
                // all we need to do is to give the fireballNode the right starting position!!
                // use same direction vector
                fireballNode.position = wandNode.convertPosition(tipNode.position, to: sceneView.scene.rootNode)
                wandIsRecharging = true
                wandNode.position.z = -0.2
                wandNode.runAction(SCNAction.moveBy(x: 0, y: 0, z: -0.1, duration: Wand.RECHARGE_TIME))
                tipNode.scale = SCNVector3(0,0,0)
                tipNode.runAction(SCNAction.scale(to: 1, duration: Wand.RECHARGE_TIME)) {
                    self.wandIsRecharging = false
                }
            }
            
            fireballNode.physicsBody?.applyForce(direction * Fireball.INITIAL_VELOCITY, asImpulse: true)
            n.removeFromParentNode()
            
            fireballNode.runAction(SCNAction.wait(duration: Fireball.TTL)) {
                fireballNode.removeFromParentNode()
            }
            
            playerNode!.runAction(SCNAction.playAudio(Sound.fireball.source,
                                                      waitForCompletion: false))
            
            return
        }
        
        if isReadyToStart,
            !isPlaying,
            let planeData = anyPlaneFrom(location: sender.location(in: sceneView)) {
            isPlaying = true
            
            didCollectCoinFromBox.removeAll()
            level?.container.removeFromParentNode()
            
            playerState = PlayerState()
            
            level!.container.position = planeData.1
            //level!.container.scale = SCNVector3(1,0,1)
            sceneView.scene.rootNode.addChildNode(level!.container)
            
            var camPos = sceneView.pointOfView!.position
            camPos.y = planeData.1.y
            //level!.container.look(at: camPos)
            
            let localCamPos = sceneView.scene.rootNode.convertPosition(sceneView.pointOfView!.position,
                                                                       to: level!.container)
            
            playerNode?.removeFromParentNode()
            playerNode = Player.node()
            playerNode!.position = localCamPos
            playerNode!.position.y = Float(Player.HEIGHT * 0.5)
            level?.container.addChildNode(playerNode!)
            
            rotationTrack = .started(position: planeData.1, screenCenter: view.center)
            let trackNode1 = SCNNode(geometry: SCNSphere(radius: 0.1))
            trackNode1.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            trackNode1.position = planeData.1
            trackNode1.name = "trackNode1"
            sceneView.scene.rootNode.addChildNode(trackNode1)
            let trackNode2 = SCNNode(geometry: SCNSphere(radius: 0.1))
            trackNode2.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            trackNode2.position = planeData.1
            trackNode2.name = "trackNode2"
            sceneView.scene.rootNode.addChildNode(trackNode2)
        }
    }
    
    private func grant(pickup:Pickup) {
        playerState = playerState.setPickup(pickup)
        playerNode!.runAction(SCNAction.playAudio(Sound.powerUp.source,
                                                  waitForCompletion: false))
        //Anim2D.granted(pickup: pickup, scene: sceneView.overlaySKScene!)
    }
    
    private func incrementScore(_ pts:Int) {
        playerState = playerState.incrementScore(pts)
        Anim2D.score(pts,
                     scene: sceneView.overlaySKScene!)
    }
    
    private func gainedLife() {
        playerState = playerState.gainLife()
        playerNode!.runAction(SCNAction.playAudio(Sound.oneUp.source,
                                                  waitForCompletion: false))
        
        Anim2D.gainedLife(scene: sceneView.overlaySKScene!)
    }
    
    private func lostLife() {
        playerState = playerState.looseLife()
        //TODO: check if lives == 0
        playerNode!.runAction(SCNAction.playAudio(Sound.takeDamage.source,
                                                  waitForCompletion: false))
        
        Anim2D.lostLife(scene: sceneView.overlaySKScene!)
    }
    
    // MARK: - ARSCNViewDelegate
    
    var overHoleTime:Date?
    var isInAirCacheState = false
    var collidedDuringJump = false
    var didCollectCoinFromBox = [String:Bool]()
    var justLanded = false
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate,
            let ambientLight = level?.container.light {
            ambientLight.temperature = lightEstimate.ambientColorTemperature
            ambientLight.intensity = lightEstimate.ambientIntensity
        }
        
        if case .started(let position, let screenCenter) = rotationTrack {
            if let planeData = anyPlaneFrom(location: screenCenter) {
                level?.container.eulerAngles = SCNVector3(0, atan2(planeData.1.x - position.x, planeData.1.z - position.z), 0)
                sceneView.scene.rootNode.childNode(withName: "trackNode2", recursively: false)?.position = planeData.1
            }
        }
        
        if isPlaying,
            let rawCamPos = sceneView.pointOfView?.position,
            let level = level {
            
            justLanded = false
            let isInAir = jumpDetecter != nil && jumpDetecter!.isInAir
            
            let camPos = sceneView.scene.rootNode.convertPosition(rawCamPos,
                                                                  to: level.container)
            
            playerNode!.position.x = camPos.x
            playerNode!.position.z = camPos.z
            //playerNode!.position.y = Float(Player.HEIGHT * 0.5) + Float(isInAir ? 1 : 0)
            
            
            //TODO: this jump state handling should be replace by a jump delegate!!
            if isInAirCacheState != isInAir {
                isInAirCacheState = isInAir
                if isInAir {
                    collidedDuringJump = false
                    playerNode!.runAction(SCNAction.playAudio(Sound.jump.source,
                                                              waitForCompletion: false))
                    playerNode!.runAction(SCNAction.moveBy(x: 0, y: Player.JUMP_ALTITUDE, z: 0, duration: 0.4))
                } else {
                    justLanded = true
                    playerNode!.position.y = Float(Player.HEIGHT * 0.5)
                }
            }
            
            for (entityId, entity) in level.entities {
                switch entity {
                case .hole:
                    break
                    /*
                     // if in the air: DO NOT CHECK!
                     if isInAir {
                     overHoleTime = nil
                     continue }
                     
                     guard let havenNode = level.nodes[entityId] else {
                     overHoleTime = nil
                     continue }
                     
                     if havenNode.position.x + Float(Hole.HOLE_DEPTH) * -0.5 <= camPos.x &&
                     havenNode.position.x + Float(Hole.HOLE_DEPTH) * 0.5 >= camPos.x &&
                     havenNode.position.z + Float(Hole.HOLE_WIDTH) * -0.5 <= camPos.z &&
                     havenNode.position.z + Float(Hole.HOLE_WIDTH) * 0.5 >= camPos.z {
                     if overHoleTime == nil {
                     overHoleTime = Date()
                     continue
                     }
                     if Date().timeIntervalSince(overHoleTime!) < 0.4 {
                     continue
                     }
                     
                     (sceneView.overlaySKScene?.childNode(withName: "thatLabel") as? SKLabelNode)?.text = "Fell down!"
                     isPlaying = false
                     
                     // player falls down by moving the entire (level) world UP!
                     let falldownAction = SCNAction.moveBy(x: 0,
                     y: CGFloat(-havenNode.position.y),
                     z: 0,
                     duration: 0.3)
                     level.container.runAction(falldownAction)
                     }
                     */
                    
                default:break
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !isReadyToStart,
            let _ = anchor as? ARPlaneAnchor else { return }
        
        isReadyToStart = true
        (sceneView.overlaySKScene?.childNode(withName: "thatLabel") as? SKLabelNode)?.isHidden = true
    }
    
    // MARK: - SCNPhysicsContactDelegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if isInAirCacheState {
            if collidedDuringJump {
                return
            }
            collidedDuringJump = true
        }
        
        guard let level = level else { return }
        
        // https://stackoverflow.com/questions/27372138/how-to-set-up-scenekit-collision-detection
        let contactMask = contact.nodeA.physicsBody!.categoryBitMask | contact.nodeB.physicsBody!.categoryBitMask
        
        if contactMask == (CollisionTypes.player.rawValue | CollisionTypes.coin.rawValue) {
            // player interacts with coin!
            let coinNode = (contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.coin.rawValue ? contact.nodeA : contact.nodeB).parent!
            // is the coin still in the game?
            guard let _ = level.nodes[coinNode] else { return }
            collectionCoin(node: coinNode, id: level.nodes[coinNode]!)
            //} else if contactMask == (CollisionTypes.player.rawValue | CollisionTypes.box.rawValue) {
        } else if contactMask & (CollisionTypes.player.rawValue | CollisionTypes.box.rawValue) == (CollisionTypes.player.rawValue | CollisionTypes.box.rawValue) {
            //determine which type of box?
            let boxNode = (contact.nodeA.physicsBody!.categoryBitMask & CollisionTypes.box.rawValue == CollisionTypes.box.rawValue ? contact.nodeA : contact.nodeB).parent!
            guard let id = level.nodes[boxNode],
                let entity = level.entities[id],
                case .block(let boxType) = entity else { return }
            
            switch boxType {
            case .usedPowerUp:
                fallthrough
            case .solid:
                playerNode!.runAction(SCNAction.playAudio(Sound.bump.source,
                                                          waitForCompletion: false))
                
            case .powerUp(let powerUp, let path):
                transformBox(to: .usedPowerUp, node: boxNode, id: id)
                
                switch powerUp ?? PowerUp.random {
                case .life:
                    gainedLife()
                case .coin:
                    spawnAndCollectCoin(position: boxNode.position)
                case .wand:
                    playerNode!.runAction(SCNAction.playAudio(Sound.powerUpAppears.source,
                                                              waitForCompletion: false))
                    
                    let id = UUID().uuidString
                    let fireballPowerUpNode = Wand.node()
                    // position on top of box..
                    fireballPowerUpNode.position = boxNode.position
                    fireballPowerUpNode.position.y += Float(Block.BLOCK_SIZE)
                    level.container.addChildNode(fireballPowerUpNode)
                    self.level!.entities[id] = .pickup(pickup: .fireballPowerUp)
                    self.level!.nodes[fireballPowerUpNode] = id
                    // move according ot its path (to go down on floor level..)
                    if !path.isEmpty {
                        // (toMove:Int, altitude:CGFloat)
                        
                        var currentPosition = fireballPowerUpNode.position
                        var actions = [SCNAction]()
                        for moveData in path {
                            
                            // move +Z
                            var toPosition = currentPosition
                            toPosition.z += Float(Block.BLOCK_SIZE) * Float(moveData.toMove)
                            var distance = currentPosition.distance(vector: toPosition)
                            var duration = TimeInterval(distance) * TimeInterval(Wand.METERS_PER_SECOND)
                            actions.append(SCNAction.move(to: toPosition, duration: duration))
                            currentPosition = toPosition
                            
                            // move down -Y
                            toPosition.y -= Float(moveData.altitude)
                            distance = currentPosition.distance(vector: toPosition)
                            duration = TimeInterval(distance) * TimeInterval(Wand.METERS_PER_SECOND)
                            actions.append(SCNAction.move(to: toPosition, duration: duration))
                            currentPosition = toPosition
                        }
                        let moveActionsSequence = SCNAction.sequence(actions)
                        
                        fireballPowerUpNode.runAction(moveActionsSequence)
                        
                    }
                }
                
            case .destructible:
                if 0 == arc4random_uniform(2) {
                    didCollectCoinFromBox[id] = true
                    spawnAndCollectCoin(position: boxNode.position)
                    
                } else {
                    if let didCollect = didCollectCoinFromBox[id], didCollect {
                        // no more coins, turn solid!
                        playerNode!.runAction(SCNAction.playAudio(Sound.bump.source,
                                                                  waitForCompletion: false))
                        transformBox(to: .solid, node: boxNode, id: id)
                        
                    } else {
                        destroyBox(node: boxNode, id: id)
                    }
                    
                }
                
            }
            
        } else if contactMask == (CollisionTypes.player.rawValue | CollisionTypes.monster.rawValue) {
            let monsterPhysicsNode = contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.monster.rawValue ? contact.nodeA : contact.nodeB
            let monsterNode = monsterPhysicsNode.parent!
            
            // cannot collide with a dead monster (physicsBody removed..)
            guard !isInAirCacheState,
                let id = level.nodes[monsterNode],
                let entity = level.entities[id],
                case .monster(_,_) = entity else { return }
            
            if justLanded {
                playerNode!.runAction(SCNAction.playAudio(Sound.stomp.source,
                                                          waitForCompletion: false))
                incrementScore(100)
                self.level!.entities[id] = .monster(isAlive: false, path: [])
                animateMonsterDeath(monsterPhysicsNode: monsterPhysicsNode,
                                    monsterNode: monsterNode)
                
            } else {
                // move away, relative to the player
                level.container.position.z -= 1
                
                lostLife()
            }
        } else if contactMask == (CollisionTypes.player.rawValue | CollisionTypes.flagPoleBase.rawValue) {
            let flagBaseNode = contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.flagPoleBase.rawValue ? contact.nodeA : contact.nodeB
            let flagNode = flagBaseNode.parent!
            
            guard !isInAirCacheState,
                let id = level.nodes[flagNode],
                let entity = level.entities[id],
                case .flagPole(_) = entity,
                let flagItself = flagNode.childNode(withName: FlagPole.FLAG_NODE_NAME, recursively: true) else { return }
            
            playerNode!.runAction(SCNAction.playAudio(Sound.flagPole.source,
                                                      waitForCompletion: false))
            
            flagBaseNode.physicsBody = nil
            self.level!.entities[id] = .flagPole(isFlagUp: false)
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3
            flagItself.position.y = Float(FlagPole.FLAG_BASE_HEIGHT + FlagPole.FLAG_SIZE * 0.5)
            SCNTransaction.commit()
            
            flagItself.runAction(SCNAction.wait(duration: 3)) {
                Anim2D.completed(scene: self.sceneView.overlaySKScene!)
            }
        } else if contactMask == (CollisionTypes.player.rawValue | CollisionTypes.pickup.rawValue) {
            // pickups..
            let pickupNode = contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.flagPoleBase.rawValue ? contact.nodeA : contact.nodeB
            
            guard !isInAirCacheState,
                let id = level.nodes[pickupNode],
                let entity = level.entities[id],
                case .pickup(let pickup) = entity else { return }
            
            pickupNode.physicsBody = nil
            // remove from model
            self.level!.entities.removeValue(forKey: id)
            self.level!.nodes.removeValue(forKey: pickupNode)
            
            //TODO: cant we GRAB the wand from the pickupNode and move it to the hand
            // of the player with a quick animation?!?!
            // put a wand in front of camera...
            let carryNode = Wand.wandNode()
            // these numbers are just trial and error, and they will only work as expected for iphone 6s/7 screen sizes. haha - should calculate this!
            carryNode.position = SCNVector3(0.07 - 0.01,-0.25,-0.3)
            carryNode.eulerAngles = SCNVector3(-60.0.degreesToRadians,0,30.0.degreesToRadians)
            // will probably need a'tweaking
            let movePosAction = SCNAction.moveBy(x: 0.02, y: 0, z: 0, duration: 0.7)
            let moveNegAction = SCNAction.moveBy(x: -0.02, y: 0, z: 0, duration: 0.7)
            let sequence = SCNAction.sequence([movePosAction, moveNegAction])
            carryNode.runAction(SCNAction.repeatForever(sequence))
            sceneView.pointOfView?.addChildNode(carryNode)
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.completionBlock = {
                pickupNode.removeFromParentNode()
            }
            pickupNode.opacity = 0.0
            SCNTransaction.commit()
            
            grant(pickup: pickup)
        } else if contactMask == (CollisionTypes.player.rawValue | CollisionTypes.fireball.rawValue) {
            let fireballNode = contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.fireball.rawValue ? contact.nodeA : contact.nodeB
            // remove fireball instantly
            fireballNode.removeFromParentNode()
            lostLife()
        } else if contactMask == (CollisionTypes.monster.rawValue | CollisionTypes.fireball.rawValue) {
            let monsterPhysicsNode = contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.monster.rawValue ? contact.nodeA : contact.nodeB
            let monsterNode = monsterPhysicsNode.parent!
            let fireballNode = contact.nodeA.physicsBody!.categoryBitMask == CollisionTypes.fireball.rawValue ? contact.nodeA : contact.nodeB
            
            // cannot collide with a dead monster (physicsBody removed..)
            guard let id = level.nodes[monsterNode] else { return }
            // remove fireball instantly
            fireballNode.removeFromParentNode()
            incrementScore(100)
            self.level!.entities[id] = .monster(isAlive: false, path: [])
            animateMonsterDeath(monsterPhysicsNode: monsterPhysicsNode,
                                monsterNode: monsterNode)
        }
        
        //TODO: (re-)implement falling into the hole (and jumping over it)
    }
    
    private func animateMonsterDeath(monsterPhysicsNode:SCNNode, monsterNode:SCNNode) {
        monsterPhysicsNode.physicsBody = nil
        monsterPhysicsNode.removeAllActions()
        monsterNode.removeAllActions()
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.8
        monsterNode.opacity = 0.3
        monsterNode.position = SCNVector3(monsterNode.position.x, -1, monsterNode.position.z)
        SCNTransaction.commit()
    }
    
    private func spawnAndCollectCoin(position:SCNVector3) {
        let coinNode = Coin.node()
        coinNode.position = position
        let id = UUID().uuidString
        self.level!.entities[id] = .coin
        self.level!.nodes[coinNode] = id
        self.level!.container.addChildNode(coinNode)
        collectionCoin(node: coinNode, id: id)
    }
    
    private func collectionCoin(node:SCNNode, id:String) {
        playerNode?.runAction(SCNAction.playAudio(Sound.coin.source,
                                                  waitForCompletion: false))
        
        self.level!.entities.removeValue(forKey: id)
        self.level!.nodes.removeValue(forKey: node)
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.completionBlock = {
            node.removeFromParentNode()
            self.incrementScore(200)
        }
        node.position = playerNode!.position
        node.opacity = 0.1
        SCNTransaction.commit()
    }
    
    private func destroyBox(node:SCNNode, id:String) {
        // just break box!
        playerNode!.runAction(SCNAction.playAudio(Sound.breakBlock.source,
                                                  waitForCompletion: false))
        self.level!.entities.removeValue(forKey: id)
        self.level!.nodes.removeValue(forKey: node)
        
        //TODO: provide a nice animation of destroying the box!
        node.removeFromParentNode()
    }
    
    private func transformBox(to boxType:BlockType, node:SCNNode, id:String) {
        let newBoxNode = Block.node(boxType: boxType)
        newBoxNode.position = node.position
        level!.container.addChildNode(newBoxNode)
        self.level!.entities[id] = .block(type: boxType)
        self.level!.nodes[newBoxNode] = id
        // remove old node
        self.level!.nodes.removeValue(forKey: node)
        node.removeFromParentNode()
    }
}
