//
//  PlaytestScreen.swift
//  Mini2
//
//  Created by Leo Harnadi on 24/06/23.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI

class PlaytestScreen: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var viewModel = GameData.shared
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    //Player
    var playerSprite: SKSpriteNode!
    var playerEntity: GKEntity!
    var playerPhysics: SKPhysicsBody!
    var playerMovementComponent: MovementComponent!
    
    //NPC
    var enemySprite: SKSpriteNode!
    var enemyEntity: GKEntity!
    var enemyPhysics: SKPhysicsBody!
    
    //Kalimba
    var kalimbaSprite: SKSpriteNode!
    var kalimbaScene: SKScene!
    var kalimbaCollision: SKNode!
    var kalimbaLight: SKLightNode!
    var kalimbaIsDropped: Bool = false
    
    //Lock
//    var lockSprite: SKSpriteNode!
    var lockScene: SKScene!
    
    //Shelf
    var cupboardSprite: SKSpriteNode!
    var shelfScene: SKScene!
    
    //photo
    var photoSprite: SKSpriteNode!
    
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
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        self.isUserInteractionEnabled = true
        
        //Assign objects from scene editor
        playerSprite = self.childNode(withName: "Player") as? SKSpriteNode
        cameraNode = self.childNode(withName: "Camera") as? SKCameraNode
        cupboardSprite = self.childNode(withName: "Cupboard") as? SKSpriteNode
        photoSprite = self.childNode(withName: "Photo") as? SKSpriteNode
        leftWall = self.childNode(withName: "LeftWall") as? SKSpriteNode
        rightWall = self.childNode(withName: "RightWall") as? SKSpriteNode
        floor = self.childNode(withName: "Floor") as? SKSpriteNode
        enemySprite = self.childNode(withName: "Enemy") as? SKSpriteNode
        innTot = cameraNode.childNode(withName: "InnTot")
        innTotLabel = innTot.childNode(withName: "InnTotLabel") as? SKLabelNode
        kalimbaSprite = self.childNode(withName: "Kalimba") as? SKSpriteNode
        viewModel.lockSprite = self.childNode(withName: "Lock") as? SKSpriteNode
        kalimbaCollision = kalimbaSprite.childNode(withName: "KalimbaCollision")
        kalimbaLight = kalimbaSprite.childNode(withName: "KalimbaLight") as? SKLightNode
        
        //Assign movement component to playerEntity
        playerEntity = createEntity(node: playerSprite, wantMovementComponent: true)
        entities.append(playerEntity)
        playerMovementComponent = playerEntity.component(ofType: MovementComponent.self)
        
        //Load animation frames
        playerMovementComponent.loadWalkAnim(frames: 14, framesInterval: 0.08)
        
        //Assign movement component to enemy
        //        enemyEntity = createEntity(node: enemySprite, wantMovementComponent: true)
        //        entities.append(enemyEntity)
        
        //Add movement component to system
        //        for entity in entities {
        //            movementComponentSystem.addComponent(foundIn: entity)
        //        }
        
        
        //Camera Constraints
        let range = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(range, to: playerSprite)
        
        let xInset = view.bounds.width * cameraNode.xScale
        let yInset = view.bounds.height * cameraNode.yScale
        
        let xRange = SKRange(lowerLimit: leftWall.frame.maxX + xInset, upperLimit: rightWall.frame.minX - xInset)
        let yRange = SKRange(lowerLimit: floor.frame.minY + yInset, upperLimit: 1000)
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        
        cameraNode.constraints = [playerConstraint,edgeConstraint]
        
        //Hide InnTot
        innTot.alpha = 0
        createInnTot(duration: 5, label: "What the, where am I?")
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
        playerMovementComponent.move(to: joystickVelocity)
    }
    
//    @EnvironmentObject var gameData: GameData
    
    func presentPopUpScene(popUpSceneName: String){
        let popUpScene = SKScene(fileNamed: popUpSceneName)
        popUpScene?.scaleMode = .aspectFit
        
        viewModel.popUpName = popUpSceneName
        viewModel.isPopUpVisible.toggle()
        self.isPaused = true
    }
    
    func presentImageDetail(imageDetailName: String){
        viewModel.imageDetailName = imageDetailName
        viewModel.isSecondPopUpVisible.toggle()
        self.isPaused = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the initial touch position
        if let touch = touches.first {
            initialTouchPosition = touch.location(in: view)
            startMoving = true
            
            viewModel.isPopUpVisible = false
            viewModel.isSecondPopUpVisible = false
            self.isPaused = false
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            
            guard let touchedNode = atPoint(location) as? SKSpriteNode else{ return}
            
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
        
        //        if (nodeA == playerSprite && nodeB == enemySprite) || (nodeA == enemySprite && nodeB == playerSprite) {
        //            if nodeA == playerSprite {
        //                nodeA?.removeFromParent()
        //            } else {
        //                nodeB?.removeFromParent()
        //            }
        //        }
        if (nodeA == playerSprite && nodeB == kalimbaCollision) || (nodeA == kalimbaCollision && nodeB == playerSprite) {
            
            if nodeA == kalimbaCollision {
                nodeA?.removeFromParent()
            } else {
                nodeB?.removeFromParent()
            }
            
            kalimbaSprite.physicsBody?.isDynamic = true
        }
        
        if (nodeA == kalimbaSprite && nodeB == floor) || (nodeA == kalimbaSprite && nodeB == floor) {
            
            if !kalimbaIsDropped {
                createInnTot(duration: 5, label: "What was that?")
                
                kalimbaLight.falloff = 3
                kalimbaIsDropped = true
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
            "Door":"The door is stuck",
            "Cupboard":"The cupboard is locked up"
        ]
        
        if touchedNode == kalimbaSprite && kalimbaIsDropped{
            presentPopUpScene(popUpSceneName: "KalimbaScene")
        } else  if touchedNode == viewModel.lockSprite {
            presentPopUpScene(popUpSceneName: "LockScene")
        }else if touchedNode == cupboardSprite && viewModel.lockUnlocked {
            presentPopUpScene(popUpSceneName: "ShelfScene")
        }else if touchedNode == photoSprite {
            presentImageDetail(imageDetailName: "OL Photo Detail")
        }else {
            if let nodeName = touchedNode.name, let comboDescription = combos[nodeName] {
                createInnTot(duration: 3, label: comboDescription)
            }
        }
    }
}
