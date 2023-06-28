//
//  ShelfScene.swift
//  Mini2
//
//  Created by beni garcia on 28/06/23.
//

import Foundation
import SpriteKit
import SwiftUI

class ShelfScene: SKScene{
    @ObservedObject var viewModel: GameData = GameData.shared
    var bgShelf : SKSpriteNode?
    var paperShelves : [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        for i in 0..<3 {
            let paper = childNode(withName: "PaperShelf\(i+1)") as? SKSpriteNode
            
            paperShelves.append(paper!)
        }
        bgShelf = childNode(withName: "bg_shelf") as? SKSpriteNode
        bgShelf?.color = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for i in 0..<3{
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == paperShelves[i] {
                    print("\(paperShelves[i])")
                    viewModel.imageDetailName = "note"
                    viewModel.isSecondPopUpVisible = true
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == bgShelf {
                if viewModel.isSecondPopUpVisible{
                    viewModel.isSecondPopUpVisible = false
                }else{
                    viewModel.isPopUpVisible = false
                }
                
            }
        }
    }
    
}
