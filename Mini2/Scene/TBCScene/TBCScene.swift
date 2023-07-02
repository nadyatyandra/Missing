//
//  TBCScene.swift
//  Mini2
//
//  Created by beni garcia on 02/07/23.
//

import Foundation
import SpriteKit
import SwiftUI

class TBCScene: SKScene{
    @ObservedObject var viewModel = GameData.shared
    
    override func didMove(to view: SKView) {
        let audioNode = SKAudioNode(fileNamed: "background music of to be continued")
        audioNode.autoplayLooped = false // Set it to not loop the sound
        audioNode.isPositional = false // Set it to non-positional sound
        
        addChild(audioNode) // Add the audio node to your scene
        
        audioNode.run(SKAction.play())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            guard let touchedNode = atPoint(location) as? SKNode else{ return }
            
            processTouch(touchedNode: touchedNode)
        }
    }
    
    func processTouch(touchedNode: SKNode) {
        
        if touchedNode.name == "TBCBackground" || touchedNode.name == "TBCText"{
            viewModel.transitionScene(scene: self, toScene: "SplashScene")
        }
    }
}
