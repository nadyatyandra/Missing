//
//  DeskScene.swift
//  Mini2
//
//  Created by Nadya Tyandra on 29/06/23.
//

import Foundation
import SpriteKit
import SwiftUI

class DeskScene: SKScene{
    @ObservedObject var viewModel: GameData = GameData.shared
    var bgDesk : SKSpriteNode?
    var employeeFileBook : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        employeeFileBook = childNode(withName: "employeeFileBook") as? SKSpriteNode
        bgDesk = childNode(withName: "bg_desk") as? SKSpriteNode
        bgDesk?.color = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == employeeFileBook {
                viewModel.imageDetailName = "OL Employee File Book Base"
                viewModel.isSecondPopUpVisible = true
                viewModel.isThirdPopUpVisible = true
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == bgDesk {
                if viewModel.isSecondPopUpVisible{
                    viewModel.isSecondPopUpVisible = false
                } else{
                    viewModel.isPopUpVisible = false
                }
            }
        }
    }
}
