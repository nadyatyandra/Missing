//
//  InnTotScene.swift
//  Mini2
//
//  Created by Leo Harnadi on 30/06/23.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI

class InnTotScene: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var viewModel = GameData.shared
    
    private var lastUpdateTime : TimeInterval = 0
    
    //Inner Thought
    var innTot: SKNode!
    var innTotLabel: SKLabelNode!
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        self.lastUpdateTime = 0
        
        innTot = self.childNode(withName: "InnTot")
        innTotLabel = innTot.childNode(withName: "InnTotLabel") as? SKLabelNode
        
        //Hide InnTot
//        viewModel.isSecondPopUpVisible.toggle()
        innTot.alpha = 0
        createInnTot(duration: viewModel.innTotDuration, label: viewModel.innTotText)
    }
    
    override func willMove(from view: SKView) {
            super.willMove(from: view)
            
        }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        
        
    }
    
    
    func createInnTot(duration: Double, label: String) {
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let wait = SKAction.wait(forDuration: duration)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let sequence = SKAction.sequence([fadeIn,wait,fadeOut])
        
        innTot.alpha = 0
        innTot.removeAllActions()
        
        innTotLabel.text = label
        
        innTot.run(sequence)
    }
    
}
