//
//  SoundComponent.swift
//  Mini2
//
//  Created by Matthew Togi on 23/06/23.
//

import Foundation
import GameplayKit

class SoundComponent: GKComponent {
    var node: SKNode
    
    init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func playSound(soundName: String) {
        let soundEffect = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
        
        node.run(soundEffect)
    }
    
}
