//
//  InteractionComponent.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import GameplayKit
import SpriteKit
enum Action : Equatable   {
    case none
    case move(ActionState, CGPoint?)

}
enum ActionState : Equatable {
    case began
    case changed
    case ended
}
class InteractionComponent : GKComponent {
    var didBegin : Bool = false
    var state : Action = .none {
        didSet {
            switch state {
            case .move(let actionState, _):
                if actionState == .began {
                    self.didBegin = true
                }
            default:
                break
            }
        }
    }
    var offset : CGPoint = .zero

}

