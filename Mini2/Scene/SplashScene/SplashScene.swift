//
//  SplashScene.swift
//  Mini2
//
//  Created by beni garcia on 01/07/23.
//

import Foundation
import SpriteKit
import SwiftUI


class SplashScene: SKScene{
    @ObservedObject var viewModel = GameData.shared
    
    var textures: [SKTexture] = []

    var logoMissing: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        for i in 100...159 {
            let texture = SKTexture(imageNamed: "Comp\(i).png")
            
            textures.append(texture)
        }
        
        logoMissing = childNode(withName: "LogoMissing") as? SKSpriteNode

        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.08)
        let sequence = SKAction.repeatForever(animationAction)
        logoMissing!.run(sequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            guard let touchedNode = atPoint(location) as? SKNode else{ return }
            
            processTouch(touchedNode: touchedNode)
        }
    }
    
    func processTouch(touchedNode: SKNode) {
        
        if touchedNode.name == "SplashScreen" || touchedNode.name == "LogoMissing"{
            viewModel.transitionScene(scene: self, toScene: "ModernLibraryScene")
        }
    }
}
