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

class ModernLibraryScene: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var viewModel = GameData.shared
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    //Player
    var playerSprite: SKSpriteNode!
    var playerEntity: GKEntity!
    var playerPhysics: SKPhysicsBody!
    var playerMovementComponent: MovementComponent!
    
    //Camera
    var cameraNode: SKCameraNode!
    
    //Environment
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    var floor: SKSpriteNode!
    var desk: SKSpriteNode!
    var painting: SKSpriteNode!
    var book: SKSpriteNode!
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
    
    //Tutorial
    var tutorialCollision: SKNode!
    var tutorialTriggered: Bool = false
    
    //Background Music
    var bgmScene: BGMScene!
    var deskSound: SoundComponent!
    var paintingSound: SoundComponent!
    var bookSound: SoundComponent!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        physicsWorld.contactDelegate = self
        self.isUserInteractionEnabled = true
        
        //Play Background Music
        bgmScene = BGMScene(backgroundMusicFileName: "background music of new library")
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
        tutorialCollision = self.childNode(withName: "TutorialCollision")
        desk = self.childNode(withName: "Desk") as? SKSpriteNode
        painting = self.childNode(withName: "Photo") as? SKSpriteNode
        book = self.childNode(withName: "BookGlowing") as? SKSpriteNode
        
        bookSound = SoundComponent(node: book)
        deskSound = SoundComponent(node: desk)
        paintingSound = SoundComponent(node: painting)
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
        
        if !tutorialTriggered {
            playerMovementComponent.move(to: joystickVelocity)
        }
        
        if viewModel.isPeeled {
            viewModel.isPeeled = false
            viewModel.playVideo(scene: self, videoName: "TransitionOld", videoExt: "mp4",  xPos: cameraNode.position.x, yPos: cameraNode.position.y, durationVideo: 3, toScene: "PlaytestScreen")
            viewModel.isFourthPopUpVisible = false
        }
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
                if !tutorialTriggered && viewModel.isMove {
                    joystickVelocity = delta
                    if startMoving {
                        startMoving = false
                        playerMovementComponent.startMoving()
                    }
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
        
        if (nodeA == playerSprite && nodeB == tutorialCollision) || (nodeA == tutorialCollision && nodeB == playerSprite) {
            
            if nodeA == tutorialCollision {
                nodeA?.removeFromParent()
            } else {
                nodeB?.removeFromParent()
            }
            
            tutorialTriggered = true
            playerMovementComponent.stopMoving()
            createInnTot(duration: 3, label: "Hm, where is the librarian?")
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
    
    func processTouch(touchedNode: SKNode) {
        let combos: [String: String] = [
            "Window":"It is raining hard",
            "Clock":"It is 17:07 right now",
            "Door":"I don't feel like going back to the rain",
            "Cupboard":"The cupboard is locked",
            "BookshelfRight":"There are some books here",
            "BookshelfMiddle":"There are some books here",
            "BookshelfLeft":"Oh, there's something interesting here"
        ]
        
        if tutorialTriggered {
            if touchedNode.name == "Desk" {
                deskSound.playSound(soundName: "table interact")
                presentImageDetail(imageDetailName: "DetailDeskML")
                
                viewModel.createInnTot(duration: 3, label: "I guess she's not here, nothing interesting otherwise")
                
                tutorialTriggered = false
            } else {
                createInnTot(duration: 3, label: "I should check the librarian's desk")
            }
        } else if touchedNode.name == "Desk" {
            deskSound.playSound(soundName: "table interact")
            presentImageDetail(imageDetailName: "DetailDeskML")
            viewModel.createInnTot(duration: 3, label: "The librarian's not here")
        } else if touchedNode.name == "BookGlowing" {
            bookSound.playSound(soundName: "book interact")
            viewModel.isFourthPopUpVisible = true
            viewModel.createInnTot(duration: 3, label: "I guess this is the school's history book")
        } else if touchedNode.name == "Photo" {
            paintingSound.playSound(soundName: "painting interact")
            presentImageDetail(imageDetailName: "DetailPhotoML")
            viewModel.createInnTot(duration: 3, label: "This was taken recently")
        } else if let nodeName = touchedNode.name, let comboDescription = combos[nodeName] {
            createInnTot(duration: 3, label: comboDescription)
        }
    }
}
