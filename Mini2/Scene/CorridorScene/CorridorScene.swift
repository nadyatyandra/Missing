//
//  CorridorScene.swift
//  Mini2
//
//  Created by Leo Harnadi on 28/06/23.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI

class CorridorScene: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var viewModel = GameData.shared
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    //Player
    var playerSprite: SKSpriteNode!
    var playerEntity: GKEntity!
    var playerPhysics: SKPhysicsBody!
    var playerMovementComponent: MovementComponent!
    
    //Enemy
    var enemySprite: SKSpriteNode!
    var enemyEntity: GKEntity!
    var enemyMovementComponent: MovementComponent!
    
    //Camera
    var cameraNode: SKCameraNode!
    
    //Environment
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var floor: SKSpriteNode!
    
    //Inner Thought
    var innTot: SKNode!
    var innTotLabel: SKLabelNode!
    
    //Component
    let movementComponentSystem = GKComponentSystem(componentClass: MovementComponent.self)
    var movementComponent: MovementComponent?
    
    //Joystick variables
    var initialTouchPosition: CGPoint?
    var joystickVelocity: CGFloat = 0
    
    //For animation
    var startMoving: Bool = false
    
    //Enemy Chase Collision
    var chaseCollision: SKNode!
    var chaseStarted: Bool = false
    var enemyIsSpawning: Bool = false
    
    //Camera constraints
    var playerConstraint: SKConstraint!
    var enemyConstraint: SKConstraint!
    var edgeConstraint: SKConstraint!
    var cameraMarker: SKNode!
    
    //key
    var key: SKSpriteNode!
//    var keyIsDropped: Bool = false
    
    //Thresholds
    var brokenWindow: SKSpriteNode!
    var doorRight: SKSpriteNode!
    
    //Background Music
    var bgmScene: BGMScene!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        self.isUserInteractionEnabled = true
        
        //Play Background Music
        bgmScene = BGMScene(backgroundMusicFileName: "background music of corridor")
        bgmScene.size = self.size // Set the size of the BGMScene to match the parent scene
        bgmScene.scaleMode = self.scaleMode // Set the scale mode of the BGMScene
        self.addChild(bgmScene)
        
        //Assign objects from scene editor
        playerSprite = self.childNode(withName: "Player") as? SKSpriteNode
        cameraNode = self.childNode(withName: "Camera") as? SKCameraNode
        leftWall = self.childNode(withName: "LeftWall") as? SKSpriteNode
        rightWall = self.childNode(withName: "RightWall") as? SKSpriteNode
        floor = self.childNode(withName: "Floor") as? SKSpriteNode
        innTot = cameraNode.childNode(withName: "InnTot")
        innTotLabel = innTot.childNode(withName: "InnTotLabel") as? SKLabelNode
        enemySprite = self.childNode(withName: "Enemy") as? SKSpriteNode
        brokenWindow = self.childNode(withName: "BrokenWindow") as? SKSpriteNode
        doorRight = self.childNode(withName: "DoorRight") as? SKSpriteNode
        cameraMarker = self.childNode(withName: "CameraMarker")
        chaseCollision = cameraMarker.childNode(withName: "ChaseCollision")
        key = self.childNode(withName: "key") as? SKSpriteNode
        
        //Assign movement component to playerEntity
        playerEntity = createEntity(node: playerSprite, wantMovementComponent: true)
        entities.append(playerEntity)
        playerMovementComponent = playerEntity.component(ofType: MovementComponent.self)
        
        //Assign movement component to enemy
        enemyEntity = createEntity(node: enemySprite, wantMovementComponent: true)
        entities.append(enemyEntity)
        enemyMovementComponent = enemyEntity.component(ofType: MovementComponent.self)
        
        //Load animation frames
        playerMovementComponent.loadWalkAnim(frames: 14, framesInterval: 0.08)
        enemyMovementComponent.loadWalkAnim(frames: 8, framesInterval: 0.12)
        playerMovementComponent.loadRunAnim(frames: 7, framesInterval: 0.07)
        
        //enemy
        enemyMovementComponent.startMoving()
        
        //Add movement component to system
        //        for entity in entities {
        //            movementComponentSystem.addComponent(foundIn: entity)
        //        }
        
        
        //Camera Constraints
        let range = SKRange(constantValue: 0)
        playerConstraint = SKConstraint.distance(range, to: playerSprite)
        enemyConstraint = SKConstraint.distance(range, to: cameraMarker)
        
        let xInset = view.bounds.width * cameraNode.xScale
        let yInset = view.bounds.height * cameraNode.yScale
        
        let xRange = SKRange(lowerLimit: leftWall.frame.maxX + xInset, upperLimit: rightWall.frame.minX - xInset)
        let yRange = SKRange(lowerLimit: floor.frame.minY + yInset, upperLimit: 1000)
        edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        
        cameraNode.constraints = [playerConstraint!,edgeConstraint!]
        
        //Hide InnTot
        innTot.alpha = 0
        createInnTot(duration: 2, label: "I've escaped")
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        
        //Move Player
        //        for case let component as MovementComponent in movementComponentSystem.components {
        //            if component.node.name == "Player" {
        //                component.move(to: joystickVelocity)
        //            } else {
        //                component.move(to: 50)
        //            }
        //        }
        
        if !enemyIsSpawning {
            playerMovementComponent.move(to: joystickVelocity)
        }
        
    }
    override func willMove(from view: SKView) {
            super.willMove(from: view)
            
            // Pause the background music when the scene changes
            bgmScene.pauseBackgroundMusic()
        }
    
    func presentJigsawPuzzle(popUpSceneName: String){
        let popUpScene = SKScene(fileNamed: popUpSceneName)
        popUpScene?.scaleMode = .aspectFit
        
        viewModel.popUpName = popUpSceneName
        viewModel.isPopUpVisible.toggle()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the initial touch position
        if let touch = touches.first {
            initialTouchPosition = touch.location(in: view)
            startMoving = true
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            
            guard let touchedNode = atPoint(location) as? SKSpriteNode else { return  }
            
            processTouch(touchedNode: touchedNode)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Calculate the joystick movement based on the touch position
        if let touch = touches.first, let initialPosition = initialTouchPosition {
            let currentPosition = touch.location(in: view)
            let delta = currentPosition.x - initialPosition.x
            
            if delta > 25 || delta < -25 {
                joystickVelocity = delta
                if startMoving {
                    startMoving = false
                    playerMovementComponent.startMoving()
                }
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset the joystick movement when the touch ends
        joystickVelocity = 0
        initialTouchPosition = nil
        
        startMoving = false
        playerMovementComponent.stopMoving()
    }
    
    func createEntity(node: SKNode, wantMovementComponent: Bool) -> GKEntity {
        let entity = GKEntity()
        
        if wantMovementComponent {
            let movementComponent = MovementComponent(node: node)
            entity.addComponent(movementComponent)
        }
        
        return entity
    }
    
    func Physics(_ contact:SKPhysicsContact){
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if (nodeA == playerSprite && nodeB == chaseCollision) || (nodeA == chaseCollision && nodeB == playerSprite) {
            if nodeA == chaseCollision {
                nodeA?.removeFromParent()
            } else {
                nodeB?.removeFromParent()
            }
            spawnEnemy()
        }
        if chaseStarted {
            if (nodeA == playerSprite && nodeB == enemySprite) || (nodeA == enemySprite && nodeB == playerSprite) {
                if nodeA == playerSprite {
                    nodeA?.removeFromParent()
                    viewModel.transitionScene(scene: self, toScene: "GameOverScene")
                } else {
                    nodeB?.removeFromParent()
                    viewModel.transitionScene(scene: self, toScene: "GameOverScene")
                }
            }
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        Physics(contact)
    }
    
    func createInnTot(duration: Double, label: String) {
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let wait = SKAction.wait(forDuration: duration)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let sequence = SKAction.sequence([fadeIn,wait,fadeOut])
        
        innTot.alpha = 0
        innTot.removeAllActions()
        
        innTotLabel.text = label
        
        innTot.run(sequence)
    }
    
    func processTouch(touchedNode: SKSpriteNode) {
        let combos: [String: String] = [
            "Boxes":"There are boxes",
            "Books":"There are dropped books",
            "BookshelfLeft":"There are old bookshelves",
            "BookshelfMid":"There are old bookshelves",
            "BookshelfRight":"There are old bookshelves",
            "Clock":"There is a clock",
            "Window":"The window is locked shut",
            "Door":"The door is stuck"
        ]
        
        //        if touchedNode == kalimbaSprite && kalimbaIsDropped{
        //            presentPopUpScene(popUpSceneName: "KalimbaScene")
        //        } else  if touchedNode == lockSprite {
        //            presentPopUpScene(popUpSceneName: "LockScene")
        //        } else {
        //            if let nodeName = touchedNode.name, let comboDescription = combos[nodeName] {
        //                createInnTot(duration: 3, label: comboDescription)
        //            }
        //        }
        
        if let nodeName = touchedNode.name, let comboDescription = combos[nodeName] {
            createInnTot(duration: 3, label: comboDescription)
        }
        
        if touchedNode.name == "Mading"{
            presentJigsawPuzzle(popUpSceneName: "JigsawScene")
        }
        
    }
    
    func spawnEnemy() {
        let cameraMoveTime: Double = 2
        let fadeTime: Double = 3
        let chaseTime: Double = 20
        let moveBackTime: Double = fadeTime + 1
        let cameraMoveBackTime: Double = 1
        let controlDelay: Double = moveBackTime + cameraMoveBackTime + cameraMoveTime - 0.2
        
        let enemyWait = SKAction.wait(forDuration: cameraMoveTime)
        let fadeIn = SKAction.fadeIn(withDuration: fadeTime)
        let chase = SKAction.move(to: CGPoint(x: doorRight!.position.x,y: enemySprite.position.y), duration: chaseTime)
        let spawnEnemy = SKAction.sequence([enemyWait,fadeIn,chase])
        
        let moveToWindow = SKAction.move(to: enemySprite.position, duration: cameraMoveTime)
        let markerWait = SKAction.wait(forDuration: moveBackTime)
        let moveToPlayer = SKAction.move(to: CGPoint(x: playerSprite!.position.x,y: enemySprite.position.y), duration: cameraMoveBackTime)
        let moveCamera = SKAction.sequence([moveToWindow,markerWait,moveToPlayer])
        
        enemySprite.run(spawnEnemy)
        cameraMarker.run(moveCamera)
        cameraNode.constraints = [enemyConstraint!,edgeConstraint!]
        playerMovementComponent.stopMoving()
        enemyIsSpawning = true
        
        let audioNode = SKAudioNode(fileNamed: "ghost appear")
        audioNode.autoplayLooped = false // Set it to not loop the sound
        audioNode.isPositional = false // Set it to non-positional sound
        
        addChild(audioNode) // Add the audio node to your scene
        
        let audioNode2 = SKAudioNode(fileNamed: "ghost appear two")
        audioNode2.autoplayLooped = false // Set it to not loop the sound
        audioNode2.isPositional = false // Set it to non-positional sound
        
        addChild(audioNode2) // Add the audio node to your scene
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + controlDelay) {
            audioNode.run(SKAction.play())
            audioNode2.run(SKAction.play())
            self.chaseStarted = true
            self.enemyIsSpawning = false
            self.cameraNode.constraints = [self.playerConstraint!,self.edgeConstraint!]
            self.playerMovementComponent.maxSpriteSpeed = 15
            self.playerMovementComponent.isRunning = true
        }
        
        
    }
}
