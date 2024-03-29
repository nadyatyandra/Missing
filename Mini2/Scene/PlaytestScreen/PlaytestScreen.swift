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
import AVFoundation

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
    var lockScene: SKScene!
    
    //Shelf
    var cupboardSprite: SKSpriteNode!
    var shelfScene: SKScene!
    
    //Photo
    var photoSprite: SKSpriteNode!
    
    //Desk
    var deskSprite: SKSpriteNode!
    
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
    
    func playVideo(videoName: String, videoExt: String){
        // Create an AVPlayerItem
        let videoURL = Bundle.main.url(forResource: videoName, withExtension: videoExt)!
        let playerItem = AVPlayerItem(url: videoURL)

        // Create an AVPlayer
        let player = AVPlayer(playerItem: playerItem)

        // Create an SKVideoNode with the AVPlayer
        let videoNode = SKVideoNode(avPlayer: player)

        // Set the video node's size and position
//        videoNode.size = CGSize(width: 2732, height: 2048)
        videoNode.position = CGPoint(x: 0, y: 0)

        // Add the video node to the scene
        self.addChild(videoNode)

        // Play the video
        player.play()
    }
  
    //Background Music
    var bgmScene: BGMScene!
    var cupboardSound: SoundComponent!
    var lockSound: SoundComponent!
    var photoSound: SoundComponent!
    var deskSound: SoundComponent!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        self.isUserInteractionEnabled = true
        
        //Play Background Music
        bgmScene = BGMScene(backgroundMusicFileName: "background music of old library")
        bgmScene.size = self.size // Set the size of the BGMScene to match the parent scene
        bgmScene.scaleMode = self.scaleMode // Set the scale mode of the BGMScene
        self.addChild(bgmScene)
        
        //Assign objects from scene editor
        playerSprite = self.childNode(withName: "Player") as? SKSpriteNode
        cameraNode = self.childNode(withName: "Camera") as? SKCameraNode
        cupboardSprite = self.childNode(withName: "Cupboard") as? SKSpriteNode
        photoSprite = self.childNode(withName: "Photo") as? SKSpriteNode
        deskSprite = self.childNode(withName: "Desk") as? SKSpriteNode
        leftWall = self.childNode(withName: "LeftWall") as? SKSpriteNode
        rightWall = self.childNode(withName: "RightWall") as? SKSpriteNode
        floor = self.childNode(withName: "Floor") as? SKSpriteNode
        enemySprite = self.childNode(withName: "Enemy") as? SKSpriteNode
        innTot = cameraNode.childNode(withName: "InnTot")
        innTotLabel = innTot.childNode(withName: "InnTotLabel") as? SKLabelNode
        kalimbaSprite = self.childNode(withName: "Kalimba") as? SKSpriteNode
        viewModel.lockSprite = self.childNode(withName: "Lock") as? SKSpriteNode
        viewModel.windowSprite = self.childNode(withName: "Window") as? SKSpriteNode
        kalimbaCollision = kalimbaSprite.childNode(withName: "KalimbaCollision")
        kalimbaLight = kalimbaSprite.childNode(withName: "KalimbaLight") as? SKLightNode
        
        deskSound = SoundComponent(node: deskSprite)
        photoSound = SoundComponent(node: photoSprite)
        cupboardSound = SoundComponent(node: cupboardSprite)
        lockSound = SoundComponent(node: viewModel.lockSprite!)
        
        //Assign movement component to playerEntity
        playerEntity = createEntity(node: playerSprite, wantMovementComponent: true)
        entities.append(playerEntity)
        playerMovementComponent = playerEntity.component(ofType: MovementComponent.self)
        
        //Load animation frames
        playerMovementComponent.loadWalkAnim(frames: 14, framesInterval: 0.08)
        
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
        createInnTot(duration: 5, label: "Ughh... What just happened? Where am I?")
    }
    
    override func willMove(from view: SKView) {
            super.willMove(from: view)
            
            // Pause the background music when the scene changes
            bgmScene.pauseBackgroundMusic()
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
        playerMovementComponent.move(to: joystickVelocity)
    }
    
    func presentPopUpScene(popUpSceneName: String){
        let popUpScene = SKScene(fileNamed: popUpSceneName)
        popUpScene?.scaleMode = .aspectFit
        
        viewModel.popUpName = popUpSceneName
        viewModel.isPopUpVisible.toggle()
    }
    
    func presentImageDetail(imageDetailName: String){
        viewModel.imageDetailName = imageDetailName
        viewModel.isSecondPopUpVisible.toggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the initial touch position
        if let touch = touches.first {
            initialTouchPosition = touch.location(in: view)
            startMoving = true
            
            viewModel.isPopUpVisible = false
            viewModel.isSecondPopUpVisible = false
            viewModel.isInnTotVisible = false
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
        
        if (nodeA == playerSprite && nodeB == kalimbaCollision) || (nodeA == kalimbaCollision && nodeB == playerSprite) {
            
            if nodeA == kalimbaCollision {
                nodeA?.removeFromParent()
            } else {
                nodeB?.removeFromParent()
            }
            
            kalimbaSprite.physicsBody?.isDynamic = true
        }
        
        let audioNode = SKAudioNode(fileNamed: "kalimba fall")
        audioNode.autoplayLooped = false // Set it to not loop the sound
        audioNode.isPositional = false // Set it to non-positional sound
        
        addChild(audioNode) // Add the audio node to your scene
        
        if (nodeA == kalimbaSprite && nodeB == floor) || (nodeA == kalimbaSprite && nodeB == floor) {
            if !kalimbaIsDropped {
                audioNode.run(SKAction.play())
                createInnTot(duration: 5, label: "What was that sound?")
                
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
            "Boxes":"There are boxes blocking the door",
            "Books":"There are scattered books all around",
            "BookshelfLeft":"The bookshelf looks broken down",
            "BookshelfMid":"The bookshelf looks broken down",
            "BookshelfRight":"The bookshelf looks broken down",
            "Clock":"There is an old-looking clock",
            "Window":"The window is locked shut",
            "Door":"The door is stuck",
            "Cupboard":"The cupboard is locked up"
        ]
        
        if touchedNode == kalimbaSprite && kalimbaIsDropped{
            presentPopUpScene(popUpSceneName: "KalimbaScene")
            viewModel.createInnTot(duration: 3, label: "This looks like a kalimba")
        } else if touchedNode == viewModel.lockSprite {
            lockSound.playSound(soundName: "lock interact")
            presentPopUpScene(popUpSceneName: "LockScene")
//            viewModel.createInnTot(duration: 3, label: "Seems to be locked tight, need to find the right combination")
        } else if touchedNode == cupboardSprite && viewModel.lockUnlocked {
            cupboardSound.playSound(soundName: "shelf interact")
            presentPopUpScene(popUpSceneName: "ShelfScene")
            viewModel.createInnTot(duration: 3, label: "Nice, its open")
        } else if touchedNode == viewModel.windowSprite && viewModel.windowSprite?.texture?.description.components(separatedBy: "'")[1] == "Broken window" {
            viewModel.transitionScene(scene: self, toScene: "CorridorScene")
        } else if touchedNode == photoSprite {
            photoSound.playSound(soundName: "painting interact")
            presentImageDetail(imageDetailName: "OL Photo Detail")
            viewModel.createInnTot(duration: 3, label: "Is the photo different?")
        } else if touchedNode == deskSprite {
            deskSound.playSound(soundName: "table interact")
            presentPopUpScene(popUpSceneName: "DeskDetailScene")
            viewModel.createInnTot(duration: 3, label: "Oh, there's a book here")
        } else {
            if let nodeName = touchedNode.name, let comboDescription = combos[nodeName] {
                createInnTot(duration: 3, label: comboDescription)
            }
        }
    }
}
