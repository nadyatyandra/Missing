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
    
    var logoGameOver: SKSpriteNode?
    var textures: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        for i in 100...159 {
            let texture = SKTexture(imageNamed: "Comp1_\(i).png")
            
            textures.append(texture)
        }
        let audioNode = SKAudioNode(fileNamed: "background music of game over")
        audioNode.autoplayLooped = false // Set it to not loop the sound
        audioNode.isPositional = false // Set it to non-positional sound
        
        addChild(audioNode) // Add the audio node to your scene
        
        audioNode.run(SKAction.play())
        
        logoGameOver = childNode(withName: "LogoGameOver") as? SKSpriteNode

        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.1)
        let sequence = SKAction.repeatForever(animationAction)
        logoGameOver!.run(sequence)
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
