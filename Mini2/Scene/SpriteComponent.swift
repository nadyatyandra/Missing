//
//  SpriteComponent.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import GameplayKit
import SpriteKit

class SpriteComponent : GKComponent {
    
    let sprite : SKSpriteNode
    var currentZPosition : CGFloat = 0
    
    init( name : String  ) {
        self.sprite = SKSpriteNode(imageNamed: name)
        super.init()
    }
    
    override func didAddToEntity() {
        self.sprite.entity = self.entity
        self.currentZPosition = self.sprite.zPosition
    }
    
    override func willRemoveFromEntity() {
        self.sprite.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
}
