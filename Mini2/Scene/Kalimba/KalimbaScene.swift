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

class SpriteComponent: GKComponent {
    let node: SKSpriteNode
    
    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didAddToEntity() {
        guard (entity?.component(ofType: SpriteComponent.self)?.node) != nil else { return }
        
        // Add any additional setup for the sprite node
    }
}


class KalimbaScene: SKScene {
    var playSoundAction = [SKAction.playSoundFileNamed("bamboo", waitForCompletion: false), SKAction.playSoundFileNamed("hello", waitForCompletion: false)]
//    var playSoundAction = SKAction.playSoundFileNamed("bamboo", waitForCompletion: false)
//    let playSoundAction = SKAction.playSoundFileNamed("bamboo", waitForCompletion: false)
    var kalimbaKeys: [SKSpriteNode] = []
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
//    var kalimbaSprite: SKSpriteNode?
    
    //    var audioPlayer: AVAudioPlayer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
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
                    print("touch key\(i + 1)")
                    self.run(playSoundAction[i])
                    //                    let test = SoundComponent(soundFileName: "bamboo")
                    //                    test.playSound()
                    
                    
                    // Access the associated KalimbaKeyEntity and play the sound
                    
                }
            }
        }
    }
}
