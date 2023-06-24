//
//  KalimbaScene.swift
//  Mini2
//
//  Created by Matthew Togi on 23/06/23.
//


import SpriteKit
import GameplayKit

class KalimbaKeySpriteNode: SKSpriteNode {
    var onTap: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Call the onTap closure when the sprite node is tapped
        onTap?()
    }
}

class KalimbaScene: SKScene {
    var playSoundAction = [SKAction.playSoundFileNamed("bamboo", waitForCompletion: false), SKAction.playSoundFileNamed("hello", waitForCompletion: false)]
//    var playSoundAction = SKAction.playSoundFileNamed("bamboo", waitForCompletion: false)
//    let playSoundAction = SKAction.playSoundFileNamed("bamboo", waitForCompletion: false)
    var kalimbaKeys: [SKSpriteNode] = []
    var correctKalimbaKeys =  ["k1", "k2", "k3", "k4", "k5"]
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
//    var kalimbaSprite: SKSpriteNode?
    
    //    var audioPlayer: AVAudioPlayer?
    
    //sound component test
    var kalimbaSprite: SKSpriteNode!
    var soundComponent: SoundComponent!
    let soundComponentKalimbaSystem = GKComponentSystem(componentClass: SoundComponent.self)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//    func validationKalimbaKeys(userInputKalimba:String){
//        for i in 0...6{
//            
//        }
//    }
    override func didMove(to view: SKView) {
        //test sound component
        kalimbaSprite = self.childNode(withName: "bg") as? SKSpriteNode
        soundComponent = SoundComponent(node: kalimbaSprite, soundName: "bamboo")
        let kalimbaComponent = GKEntity()
        kalimbaComponent.addComponent(soundComponent)
//        kalimbaSprite = self.childNode(withName: "Kalimba") as SKSpriteNode?
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
                    print("touch key\(id)")
//                    self.run(playSoundAction[i])
                    soundComponent.playSound(soundName: "k" + String(id))
                    //                    let test = SoundComponent(soundFileName: "bamboo")
                    //                    test.playSound()
                    
                    
                    // Access the associated KalimbaKeyEntity and play the sound
                    
                }
            }
        }
    }
}
