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
    
    //key
    var keySprite: SKSpriteNode?
    var keyPickedUp: Bool = false
    var puzzleSolved: Bool = false
    
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
    
    //Thresholds
    var brokenWindow: SKSpriteNode!
    var doorRight: SKSpriteNode!
    var doorLeft: SKSpriteNode!
    var doorMid: SKSpriteNode!
    var madingSprite: SKSpriteNode!
    
    //Background Music
    var bgmScene: BGMScene!
    var keySound: SoundComponent!
    var doorRightSound: SoundComponent!
    var doorMidSound: SoundComponent!
    var doorLeftSound: SoundComponent!
    var madingSound: SoundComponent!
    
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
        viewModel.enemySprite = self.childNode(withName: "Enemy") as? SKSpriteNode
        brokenWindow = self.childNode(withName: "BrokenWindow") as? SKSpriteNode
        doorRight = self.childNode(withName: "DoorRight") as? SKSpriteNode
        doorLeft = self.childNode(withName: "DoorLeft") as? SKSpriteNode
        doorMid = self.childNode(withName: "DoorMid") as? SKSpriteNode
        cameraMarker = self.childNode(withName: "CameraMarker")
        chaseCollision = cameraMarker.childNode(withName: "ChaseCollision")
        keySprite = self.childNode(withName: "key") as? SKSpriteNode
        madingSprite = self.childNode(withName: "Mading") as? SKSpriteNode
        
        doorLeftSound = SoundComponent(node: doorLeft!)
        doorMidSound = SoundComponent(node: doorMid!)
        doorRightSound = SoundComponent(node: doorRight!)
        keySound = SoundComponent(node: keySprite!)
        madingSound = SoundComponent(node: madingSprite!)
        
        //Assign movement component to playerEntity
        playerEntity = createEntity(node: playerSprite, wantMovementComponent: true)
        entities.append(playerEntity)
        playerMovementComponent = playerEntity.component(ofType: MovementComponent.self)
        
        //Assign movement component to enemy
        enemyEntity = createEntity(node: viewModel.enemySprite!, wantMovementComponent: true)
        entities.append(enemyEntity)
        enemyMovementComponent = enemyEntity.component(ofType: MovementComponent.self)
        
        //Load animation frames
        playerMovementComponent.loadWalkAnim(frames: 14, framesInterval: 0.08)
        enemyMovementComponent.loadWalkAnim(frames: 8, framesInterval: 0.12)
        playerMovementComponent.loadRunAnim(frames: 7, framesInterval: 0.07)
        toggleKeyVisibility(isVisible: false)

        
        
        
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
        createInnTot(duration: 2, label: "What is going on")
        enemyMovementComponent.startMoving()
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
        
        if viewModel.keyDropped {
            presentImageDetail(imageDetailName: "puzzle full")
            viewModel.keyDropped = false
            toggleKeyVisibility(isVisible: true)
            puzzleSolved = true
            viewModel.createInnTot(duration: 3, label: "Something dropped")
            let audioNode = SKAudioNode(fileNamed: "key dropped")
            audioNode.autoplayLooped = false // Set it to not loop the sound
            audioNode.isPositional = false // Set it to non-positional sound
            
            addChild(audioNode) // Add the audio node to your scene
            
            audioNode.run(SKAction.play())
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
    
    func toggleKeyVisibility(isVisible: Bool) {
        
        keySprite?.isHidden = !isVisible
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "isPopUpVisible" {
//            if let newValue = change?[.newKey] as? Bool {
//                if newValue {
//                    // Jigsaw puzzle is completed, show the key
//                    toggleKeyVisibility(isVisible: true)
//                }
//            }
//        }
//    }
    
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
                if startMoving && !enemyIsSpawning {
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
            let audioNode = SKAudioNode(fileNamed: "ghost scream")
            audioNode.autoplayLooped = false // Set it to not loop the sound
            audioNode.isPositional = false // Set it to non-positional sound
            
            addChild(audioNode) // Add the audio node to your scene
            
            audioNode.run(SKAction.play())
            if (nodeA == playerSprite && nodeB == viewModel.enemySprite) || (nodeA == viewModel.enemySprite && nodeB == playerSprite) {
                if nodeA == playerSprite {
                    nodeA?.removeFromParent()
                    audioNode.run(SKAction.play())
                    viewModel.transitionScene(scene: self, toScene: "GameOverScene")
                } else {
                    nodeB?.removeFromParent()
                    audioNode.run(SKAction.play())
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
        
        if touchedNode.name == "Mading"{
            madingSound.playSound(soundName: "painting interact")
            if !puzzleSolved{
                presentJigsawPuzzle(popUpSceneName: "JigsawScene")
            }else{
                presentImageDetail(imageDetailName: "puzzle full")
            }
            viewModel.enemySprite?.isPaused = true
        }else if keyPickedUp{
            if touchedNode.name == "DoorRight"{
                doorRightSound.playSound(soundName: "door open")
                viewModel.transitionScene(scene: self, toScene: "TBCScene")
            }else if touchedNode.name == "DoorLeft" || touchedNode.name == "DoorMid"{
//                masukkin suara door stuck @togi
                doorLeftSound.playSound(soundName: "door stuck")
                doorMidSound.playSound(soundName: "door stuck")
                
//                enemyIsSpawning = true
                createInnTot(duration: 3, label: "Uh oh the key is stuck")
                keyPickedUp = false
            }
            
        }else if touchedNode.name == "DoorRight" || touchedNode.name == "DoorMid" || touchedNode.name == "DoorLeft"{
            createInnTot(duration: 3, label: "The door can't be opened")
            doorRightSound.playSound(soundName: "door stuck")
            doorLeftSound.playSound(soundName: "door stuck")
            doorMidSound.playSound(soundName: "door stuck")
            
        }else if touchedNode.name == "key"{
            toggleKeyVisibility(isVisible: false)
            keyPickedUp = true
            createInnTot(duration: 3, label: "There's a key")
        }
          
    }
    
    func presentImageDetail(imageDetailName: String){
        viewModel.imageDetailName = imageDetailName
        viewModel.isSecondPopUpVisible.toggle()
    }
    
    func spawnEnemy() {
        let cameraMoveTime: Double = 2
        let fadeTime: Double = 3
        let chaseTime: Double = 25
        let moveBackTime: Double = fadeTime + 1
        let cameraMoveBackTime: Double = 1
        let controlDelay: Double = moveBackTime + cameraMoveBackTime + cameraMoveTime - 0.2
        
        let enemyWait = SKAction.wait(forDuration: cameraMoveTime)
        let fadeIn = SKAction.fadeIn(withDuration: fadeTime)
        let chase = SKAction.move(to: CGPoint(x: doorRight!.position.x,y: viewModel.enemySprite!.position.y), duration: chaseTime)
        let spawnEnemy = SKAction.sequence([enemyWait,fadeIn,chase])
        
        let moveToWindow = SKAction.move(to: viewModel.enemySprite!.position, duration: cameraMoveTime)
        let markerWait = SKAction.wait(forDuration: moveBackTime)
        let moveToPlayer = SKAction.move(to: CGPoint(x: playerSprite!.position.x,y: viewModel.enemySprite!.position.y), duration: cameraMoveBackTime)
        let moveCamera = SKAction.sequence([moveToWindow,markerWait,moveToPlayer])
        
        viewModel.enemySprite!.run(spawnEnemy)
        
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
        audioNode2.run(SKAction.play())
        
        createInnTot(duration: 3, label: "What was that?")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + controlDelay) {
            audioNode.run(SKAction.play())
            self.createInnTot(duration: 3, label: "I need to run")
            self.chaseStarted = true
            self.enemyIsSpawning = false
            self.cameraNode.constraints = [self.playerConstraint!,self.edgeConstraint!]
            self.playerMovementComponent.maxSpriteSpeed = 15
            self.playerMovementComponent.isRunning = true
        }
    }
}
