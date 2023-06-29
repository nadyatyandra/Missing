//
//  MovementComponent.swift
//  Mini2
//
//  Created by Leo Harnadi on 21/06/23.
//

import Foundation
import GameplayKit

class MovementComponent: GKComponent{
    
    var node: SKNode
    
    //for anim
    var spriteNode: SKSpriteNode?
    var spriteScale: CGFloat?
    
    let maxSpriteSpeed: CGFloat = 10
    let spriteSpeed: CGFloat = 10
    
    var walkFrames: [SKTexture] = []
    var walkAnimation: SKAction?
    var idleTexture: SKTexture
    
    init(node: SKNode) {
        self.node = node
        self.spriteNode = self.node as? SKSpriteNode
        if spriteNode!.xScale > 0 {
            self.spriteScale = -spriteNode!.xScale
        } else {
            self.spriteScale = spriteNode!.xScale
        }
        self.idleTexture = (self.spriteNode?.texture)!
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
    
    public func loadWalkAnim(frames: Int, framesInterval: TimeInterval){
        let fileName = "\(node.name ?? "Player")Walk"
        let animationAtlas = SKTextureAtlas(named: fileName)
        
        for i in 1...animationAtlas.textureNames.count {
//            let texture = SKTexture(imageNamed: "\(node.name ?? "Player")Walk\(i)")
//            walkFrames.append(texture)
            walkFrames.append(animationAtlas.textureNamed("\(fileName)\(i)"))
        }
        
        walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: framesInterval)
        self.walkAnimation = SKAction.repeatForever(walkAnimation!)
    }
    
    
    func startMoving() {
        spriteNode?.run(walkAnimation!, withKey: "walking")
    }
    
    func stopMoving() {
        spriteNode?.removeAction(forKey: "walking")
        spriteNode?.texture = idleTexture
    }
}
