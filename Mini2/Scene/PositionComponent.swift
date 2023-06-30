//
//  PositionComponent.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import GameplayKit
import SpriteKit

class PositionComponent : GKComponent {
    
    var currentPosition : CGPoint
    let targetPosition : CGPoint
    
    init( currentPosition : CGPoint, targetPosition : CGPoint ) {
        self.currentPosition = currentPosition
        self.targetPosition = targetPosition
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implmented")
    }
}
