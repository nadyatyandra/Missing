//
//  InteractionComponent+Interact.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import SpriteKit

extension InteractionComponent {
    override func update(deltaTime seconds: TimeInterval) {
        switch state {
        case .none:
            break
        case .move(let state, let point):
            self.handleMove(state: state, point: point)
        default:
            break
        }
    }
    
    func handleMove( state : ActionState, point : CGPoint? ) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }
        if self.didBegin {
            if let hasPoint = point {
                offset = positionComponent.currentPosition - hasPoint
            }
            entity?.component(ofType: ScaleComponent.self)?.targetScale = 1.2
            entity?.component(ofType: SpriteComponent.self)?.sprite.zPosition = 1000
            self.didBegin = false
        }
        
        if let hasPoint = point {
            positionComponent.currentPosition = hasPoint + offset
        }
        
        switch state {
        case .ended:
            self.state = .none
            offset = .zero
            entity?.component(ofType: ScaleComponent.self)?.targetScale = 1
            if let hasSpriteComponent = entity?.component(ofType: SpriteComponent.self) {
                hasSpriteComponent.sprite.zPosition = hasSpriteComponent.currentZPosition
                
                                                print(positionComponent.currentPosition)
                
            }
        default:
            break

        }
    }
}

