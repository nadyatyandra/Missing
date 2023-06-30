//
//  MovementComponent.swift
//  Mini2
//
//  Created by Leo Harnadi on 21/06/23.
//

import Foundation
import GameplayKit
import AVFAudio

class MovementComponent: GKComponent{
    
    var node: SKNode
    
    //for anim
    var spriteNode: SKSpriteNode?
    var spriteScale: CGFloat?
    var spriteSizeLeft: CGSize?
    var spriteSizeRight: CGSize?
    
    var maxSpriteSpeed: CGFloat = 10
    let spriteSpeed: CGFloat = 10
    
    var walkFrames: [SKTexture] = []
    var walkAnimation: SKAction?
    var runFrames: [SKTexture] = []
    var runAnimation: SKAction?
    var idleTexture: SKTexture
    
    var isRunning: Bool = false
    
    var audioPlayer: AVAudioPlayer?
    var soundAction: SKAction?
    init(node: SKNode) {
        self.node = node
        self.spriteNode = self.node as? SKSpriteNode
        if spriteNode!.xScale > 0 {
            self.spriteScale = -spriteNode!.xScale
        } else {
            self.spriteScale = spriteNode!.xScale
        }
        self.idleTexture = (self.spriteNode?.texture)!
        
        self.spriteSizeRight = self.spriteNode?.texture?.size()
        self.spriteSizeLeft = self.spriteNode?.size
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move(to point: CGFloat){
        let velocity = point * spriteSpeed
        let clampedVelocity = max(-maxSpriteSpeed, min(maxSpriteSpeed, velocity))
        node.position.x += clampedVelocity
        
        if velocity < 0 {
            spriteNode?.xScale = -spriteScale!
        } else if velocity > 0 {
            spriteNode?.xScale = spriteScale!
        }
    }
    
    func loadWalkAnim(frames: Int, framesInterval: TimeInterval){
        let fileName = "\(node.name ?? "Player")Walk"
        let animationAtlas = SKTextureAtlas(named: fileName)
        
        for i in 1...animationAtlas.textureNames.count {
            //            let texture = SKTexture(imageNamed: "\(node.name ?? "Player")Walk\(i)")
            //            walkFrames.append(texture)
            //            soundComponent.playSound(soundName: "walking")
            walkFrames.append(animationAtlas.textureNamed("\(fileName)\(i)"))
        }
        
        walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: framesInterval)
        self.walkAnimation = SKAction.repeatForever(walkAnimation!)
        
    }
    
    func loadRunAnim(frames: Int, framesInterval: TimeInterval){
        let fileName = "\(node.name ?? "Player")Run"
        let animationAtlas = SKTextureAtlas(named: fileName)
        
        for i in 1...animationAtlas.textureNames.count {
            runFrames.append(animationAtlas.textureNamed("\(fileName)\(i)"))
        }
        
        //        runAnimation = SKAction.animate(with: runFrames, timePerFrame: framesInterval)
        runAnimation = SKAction.animate(with: runFrames, timePerFrame: framesInterval, resize: true, restore: true)
        self.runAnimation = SKAction.repeatForever(runAnimation!)
    }
    
    func startMoving() {
        
        if isRunning {
            
            spriteNode?.run(runAnimation!, withKey: "moving")
            spriteNode?.run(SKAction.run {
                self.playSoundEffect(soundName: "running")
            })
        } else {
            spriteNode?.run(walkAnimation!, withKey: "moving")
            spriteNode?.run(SKAction.run {
                self.playSoundEffect(soundName: "walking")
            })
        }
    }
    
    func playSoundEffect(soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    func stopSoundEffect() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func stopMoving() {
        spriteNode?.run(SKAction.run {
            self.stopSoundEffect()
        })
        spriteNode?.removeAction(forKey: "moving")
        spriteNode?.texture = idleTexture
        
        
        if isRunning {
            
            if (spriteNode?.xScale)! > 0 {
                spriteNode?.size = CGSize(width: spriteSizeLeft!.width, height: spriteSizeLeft!.height)
            } else if (spriteNode?.xScale)! <= 0 {
                spriteNode?.size = CGSize(width: spriteSizeRight!.width, height: spriteSizeRight!.height)
            }
            
        }
    }
}
