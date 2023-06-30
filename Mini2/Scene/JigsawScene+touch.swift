//
//  JigsawScene+touch.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import GameplayKit
extension JigsawScene {
    
    static func scene(named : String ) -> JigsawScene {
        let puzzle = Puzzle(fileNamed: "person.json")
        let sceneSize : CGSize
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let hasPuzzle = puzzle, hasPuzzle.type == "vector" {
                sceneSize = CGSize(width: 2219, height: 1024)
            } else {
                sceneSize = CGSize(width: 4438, height: 2048)
            }
        } else {
            if let hasPuzzle = puzzle, hasPuzzle.type == "vector" {
                sceneSize = CGSize(width: 1109, height: 512)
            } else {
                sceneSize = CGSize(width: 2219, height: 1024)
            }
        }
        let scene = JigsawScene(size: sceneSize)
        scene.scaleMode = .aspectFill
        scene.puzzle = puzzle
        return scene
    }
    
    
    
    func setupInteractionHandlers() {
        let panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panRecogniser.maximumNumberOfTouches = 1
        self.view?.addGestureRecognizer(panRecogniser)
    }
    
    @objc func handlePan(_ recogniser : UIPanGestureRecognizer ) {
        let point = self.scene?.convertPoint(fromView: recogniser.location(in: self.view)) ?? .zero
        if recogniser.state == .began {
            self.entityBeingInteractedWith = self.topNode(at: point)?.entity
        }
        guard let hasEntity = self.entityBeingInteractedWith else { return }
        
        guard recogniser.numberOfTouches <= 1 else {
            self.entityBeingInteractedWith = nil
            hasEntity.component(ofType: InteractionComponent.self)?.state = .none
            return
        }
        
        switch recogniser.state {
        case .began:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.began, point)
        case .changed:
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.changed, point)
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed")
        case .ended:
            self.fixZPosition()
            hasEntity.component(ofType: InteractionComponent.self)?.state = .move(.ended, point)
            self.entityBeingInteractedWith = nil
        default:
            break
        }
    }
}

