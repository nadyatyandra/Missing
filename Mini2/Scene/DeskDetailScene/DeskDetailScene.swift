//
//  DeskDetailScene.swift
//  Mini2
//
//  Created by Nadya Tyandra on 30/06/23.
//

import Foundation
import SpriteKit
import SwiftUI

class DeskDetailScene: SKScene{
    @ObservedObject var viewModel: GameData = GameData.shared
    var employeeFileBook : SKSpriteNode?
    var soundComponent: SoundComponent!
    
    override func didMove(to view: SKView) {
        employeeFileBook = childNode(withName: "employeeFileBook") as? SKSpriteNode
        soundComponent = SoundComponent(node: employeeFileBook!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == employeeFileBook {
                soundComponent.playSound(soundName: "paper interact")
                viewModel.imageDetailName = "OL Employee File Book Base"
                viewModel.isSecondPopUpVisible = true
                viewModel.isThirdPopUpVisible = true
            }
        }
    }
}
