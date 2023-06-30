//
//  SnappingComponent+Snap.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import SpriteKit

extension SnappingComponent {
    override func update(deltaTime seconds: TimeInterval) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else { return }
        guard let interactionComponent = entity?.component(ofType: InteractionComponent.self), interactionComponent.state == .none else { return }
        let vector = positionComponent.currentPosition - positionComponent.targetPosition
        let hyp = sqrt(( vector.x * vector.x ) + (vector.y * vector.y))
        var shouldSnap = true
        if hyp > self.positionTolerance {
            shouldSnap = false
        }
        
        if shouldSnap {
            positionComponent.currentPosition = positionComponent.targetPosition
            entity?.component(ofType: SpriteComponent.self)?.sprite.zPosition = 1
        }
    }
}
