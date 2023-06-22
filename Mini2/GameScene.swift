//
//  GameScene.swift
//  Mini2
//
//  Created by Nadya Tyandra on 09/06/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    //Player
    var playerSprite: SKSpriteNode!
    let playerEntity = GKEntity()
    
    //Camera
    var cameraNode: SKCameraNode!
    
    //Walls
    var leftWall: SKSpriteNode!
    var rightWall: SKSpriteNode!
    
    //Component
    var movementComponent: MovementComponent?
    
    //Joystick variables
    var initialTouchPosition: CGPoint?
    var joystickVelocity: CGFloat = 0
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        
        
        self.isUserInteractionEnabled = true
        
        //Assign objects from scene editor
        playerSprite = self.childNode(withName: "Player") as? SKSpriteNode
        cameraNode = self.childNode(withName: "Camera") as? SKCameraNode
        leftWall = self.childNode(withName: "LeftWall") as? SKSpriteNode
        rightWall = self.childNode(withName: "RightWall") as? SKSpriteNode
        
        //Assign movement component to playerEntity
        movementComponent = MovementComponent(node: playerSprite)
        playerEntity.addComponent(movementComponent!)
        
        //Camera Constraints
        let range = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(range, to: playerSprite)
        
        let xInset = view.bounds.width * cameraNode.xScale
        
        let xRange = SKRange(lowerLimit: leftWall.frame.minX + xInset, upperLimit: rightWall.frame.maxX - xInset)
        let yRange = SKRange(lowerLimit: 0, upperLimit: 50)
        let edgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        
        cameraNode.constraints = [playerConstraint,edgeConstraint]
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
        movementComponent?.move(to: joystickVelocity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the initial touch position
        if let touch = touches.first {
            initialTouchPosition = touch.location(in: view)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Calculate the joystick movement based on the touch position
        if let touch = touches.first, let initialPosition = initialTouchPosition {
            let currentPosition = touch.location(in: view)
            let delta = currentPosition.x - initialPosition.x
            
            joystickVelocity = delta
        }
        
        
//        print(leftWall.position.x)
//        print(cameraNode.position.x)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset the joystick movement when the touch ends
        joystickVelocity = 0
        initialTouchPosition = nil
    }
    
    
}
