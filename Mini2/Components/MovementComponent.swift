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
    
    let maxSpriteSpeed: CGFloat = 20
    let spriteSpeed: CGFloat = 0.1
    
    var walkFrames: [SKTexture] = []
    var walkAnimation: SKAction?
    
    init(node: SKNode) {
        self.node = node
        self.spriteNode = self.node as? SKSpriteNode
        self.spriteScale = spriteNode?.xScale
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
    
    public func loadAnim(frames: Int){
        for i in 1...frames {
            let texture = SKTexture(imageNamed: "\(node.name ?? "Player")\(i)")
            walkFrames.append(texture)
        }
        
        walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.1)
        self.walkAnimation = SKAction.repeatForever(walkAnimation!)
    }
    
    func startMoving() {
        spriteNode?.run(walkAnimation!, withKey: "walking")
    }
    
    func stopMoving() {
        spriteNode?.removeAction(forKey: "walking")
    }
}
