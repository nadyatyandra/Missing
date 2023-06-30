//
//  Scene1.swift
//  Mini2
//
//  Created by beni garcia on 20/06/23.
//

import SpriteKit

class Scene1: SKScene, SKPhysicsContactDelegate{
    var player: SKSpriteNode?
    var note: SKSpriteNode?
    var noteZoom: SKSpriteNode?
    var lockScene: SKScene?
    var lastTouch: CGPoint? = nil
    var isMovingLeft = false
    var isMovingRight = false
    let playerSpeed: CGFloat = 200.0
    var lastUpdateTime: TimeInterval = 0
    let playSoundAction = SKAction.playSoundFileNamed("sound_note", waitForCompletion: false)
    var walkAnimation: SKAction?
    
    var playerScale: CGFloat?
    
    override func didMove(to view: SKView) {
        note = childNode(withName: "note") as? SKSpriteNode
        player = childNode(withName: "player") as? SKSpriteNode
//        let noteZoomPosition = CGPoint(x: size.width / 2, y: size.height / 2)
        noteZoom?.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        lockScene?.isHidden.toggle()
        
        var walkFrames: [SKTexture] = []
        
        // Memuat gambar sprite berjalan
        for i in 1...5 {
            let texture = SKTexture(imageNamed: "avatar\(i)")
            walkFrames.append(texture)
        }
        
        // Membuat animasi berjalan
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.1)
        self.walkAnimation = SKAction.repeatForever(walkAnimation)
        
        playerScale = player!.xScale
    }
    
    func presentLockScene() {
        // Pause the current scene, if needed
//        self.view?.isPaused = true

        // Create and present the modal scene
        lockScene = SKScene(fileNamed: "LockScene")
//        lockScene?.scaleMode = .aspectFill
        lockScene?.size = CGSize(width: self.size.width * 0.5, height: self.size.height * 0.5)
        lockScene?.scaleMode = .aspectFit
        self.view?.presentScene(lockScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == note {
                print("kepencet")
                self.run(playSoundAction)
                presentLockScene()
                
            }
            if !player!.contains(location) {
                // Memeriksa posisi sentuhan pada pemain untuk menentukan arah pergerakan
                if location.x < player!.position.x {
                    isMovingLeft = true
                    player?.run(walkAnimation!, withKey: "walking")
                    player?.xScale = -playerScale!
                } else {
                    isMovingRight = true
                    player?.run(walkAnimation!, withKey: "walking")
                    player?.xScale = playerScale!
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMovingLeft = false
        isMovingRight = false
        player?.removeAction(forKey: "walking")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Menghitung deltaTime
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Update posisi pemain berdasarkan arah pergerakan yang ditentukan
        if isMovingLeft {
            movePlayerLeft(deltaTime: deltaTime)
        } else if isMovingRight {
            movePlayerRight(deltaTime: deltaTime)
        }
    }
    
    func movePlayerLeft(deltaTime: TimeInterval) {
        let newPosition = CGPoint(x: player!.position.x - playerSpeed * CGFloat(deltaTime), y: player!.position.y)
        
        // Memeriksa batasan pergerakan ke kiri (misalnya, tepi layar atau area tertentu)
        player?.position = newPosition
        
    }
    
    func movePlayerRight(deltaTime: TimeInterval) {
        let newPosition = CGPoint(x: player!.position.x + playerSpeed * CGFloat(deltaTime), y: player!.position.y)
        
        // Memeriksa batasan pergerakan ke kanan (misalnya, tepi layar atau area tertentu)
        player?.position = newPosition
        
    }
}
