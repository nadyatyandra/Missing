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
    var diaryShelf: SKSpriteNode?
    
    var soundComponent: SoundComponent!
    var diarySound: SoundComponent!
    
    override func didMove(to view: SKView) {
        for i in 0..<8 {
            let paper = childNode(withName: "PaperShelf\(i+1)") as? SKSpriteNode
            
            paperShelves.append(paper!)
        }
        bgShelf = childNode(withName: "bg_shelf") as? SKSpriteNode
        soundComponent = SoundComponent(node: bgShelf!)
        bgShelf?.color = .clear
        diaryShelf = childNode(withName: "DiaryShelf") as? SKSpriteNode
        diarySound = SoundComponent(node: diaryShelf!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for i in 0..<8{
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == paperShelves[i] {
                    soundComponent.playSound(soundName: "paper interact")
                    print("\(paperShelves[i])")
                    viewModel.imageDetailName = "ShelfImageDetail\(i+1)"
                    viewModel.isSecondPopUpVisible = true
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == diaryShelf {
                diarySound.playSound(soundName: "diary interact")
                viewModel.isFifthPopUpVisible = true
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == bgShelf {
                if viewModel.isSecondPopUpVisible{
                    viewModel.isSecondPopUpVisible = false
                }else{
                    viewModel.isPopUpVisible = false
                }
                viewModel.isInnTotVisible = false
            }
        }
    }
}
