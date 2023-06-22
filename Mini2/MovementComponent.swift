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
    let maxSpriteSpeed: CGFloat = 20
    let spriteSpeed: CGFloat = 0.1 
    
    init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move(to point: CGFloat){
        let velocity = point * spriteSpeed
        let clampedVelocity = max(-maxSpriteSpeed, min(maxSpriteSpeed, velocity))
        
        node.position.x += clampedVelocity
    }
}
