//
//  SpriteComponent+Render.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import SpriteKit

extension SpriteComponent {
    override func update(deltaTime seconds: TimeInterval) {
        guard let hasPositionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }
        self.sprite.position = hasPositionComponent.currentPosition
        
if let hasScale = entity?.component(ofType: ScaleComponent.self), hasScale.currentScale != hasScale.targetScale {
    if hasScale.currentTime > 0 {
        hasScale.currentTime -= seconds
        let factor = CGFloat((hasScale.duration - hasScale.currentTime) / hasScale.duration)
        hasScale.currentScale = hasScale.originalScale + (hasScale.difference * factor)
        self.sprite.setScale(hasScale.currentScale)
    } else {
        hasScale.currentScale = hasScale.targetScale
        self.sprite.setScale(hasScale.currentScale)
    }
}
    }
}
