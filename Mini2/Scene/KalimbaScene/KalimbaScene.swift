//
//  KalimbaScene.swift
//  Mini2
//
//  Created by Matthew Togi on 23/06/23.
//


import SpriteKit
import GameplayKit
import SwiftUI

class KalimbaKeySpriteNode: SKSpriteNode {
    var onTap: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Call the onTap closure when the sprite node is tapped
        onTap?()
    }
}

class KalimbaScene: SKScene {
    @ObservedObject var viewModel = GameData.shared
    var kalimbaKeys: [SKSpriteNode] = []
    var correctKalimbaKeys =  ["k1", "k3", "k1", "k3", "k4", "k5", "k5"]
    var userInputKalimbaKeys: [String] = []
    var index = 0
    var bgKalimba : SKSpriteNode?
    
    var kalimbaSprite: SKSpriteNode!
    var soundComponent: SoundComponent!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func successScreen(){
        let playScene = SKScene(fileNamed: "PlaytestScreen")
        playScene?.scaleMode = .aspectFit
        self.view?.presentScene(playScene)
    }
    
    func validationKalimbaKeys(userInputKalimba:String, index:Int) -> Bool{
        if userInputKalimba.elementsEqual(correctKalimbaKeys[index]){
            return true
        } else {
            return false
        }
    }
    
    override func didMove(to view: SKView) {
        //test sound component
        kalimbaSprite = self.childNode(withName: "bg") as? SKSpriteNode
        soundComponent = SoundComponent(node: kalimbaSprite)
        bgKalimba = self.childNode(withName: "bg_kalimba") as? SKSpriteNode
        bgKalimba?.color = .clear
        
        let kalimbaComponent = GKEntity()
        kalimbaComponent.addComponent(soundComponent)
        // Get label node from scene and store it for use later
        for i in 0..<7 {
            let kalimbaKey = childNode(withName: "k\(i + 1)") as? SKSpriteNode
            kalimbaKeys.append(kalimbaKey!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            for i in 0..<7 {
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == kalimbaKeys[i] {
                    let id = i+1
                    soundComponent.playSound(soundName: "k" + String(id))
                   
                    let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.1)
                    let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.1)
                    let buttonAnimation = SKAction.sequence([scaleUpAction, scaleDownAction])
                    
                    touchedNode.run(buttonAnimation)
                    
                    if validationKalimbaKeys(userInputKalimba: "k\(id)", index: index){
                        userInputKalimbaKeys.append("k\(id)")
                        if userInputKalimbaKeys.count == correctKalimbaKeys.count{
                            soundComponent.playSound(soundName: "glass shatter")
                            soundComponent.playSound(soundName: "ghost scream")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                self.successScreen()
                                self.viewModel.isPopUpVisible = false
                                self.viewModel.createInnTot(duration: 3, label: "What the? Did something break?")
                            }
                            viewModel.windowSprite?.texture = SKTexture(imageNamed: "Broken window")
                            
                        }
                        index = index + 1
                    } else {
                        index = 0
                        userInputKalimbaKeys.removeAll()
                    }
                    
                    
                    
                    // Access the associated KalimbaKeyEntity and play the sound
                   
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == bgKalimba {
                viewModel.isPopUpVisible = false
                viewModel.isInnTotVisible = false
            }
        }
    }
}
