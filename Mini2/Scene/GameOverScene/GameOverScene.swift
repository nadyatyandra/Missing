//
//  GameOverScene.swift
//  Mini2
//
//  Created by beni garcia on 30/06/23.
//

import Foundation
import SwiftUI
import SpriteKit

class GameOverScene: SKScene{
    @ObservedObject var viewModel = GameData.shared
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            guard let touchedNode = atPoint(location) as? SKSpriteNode else{ return}
            
            processTouch(touchedNode: touchedNode)
        }
    }
    
    func processTouch(touchedNode: SKSpriteNode) {
        if touchedNode.name == "RetryButton" {
            viewModel.transitionScene(scene: self, toScene: "CorridorScene")
        }
    }
}
