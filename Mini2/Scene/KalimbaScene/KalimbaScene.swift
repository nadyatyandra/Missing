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
    var userInputKalimbaKeys: [String] = []
    var index = 0
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
    var kalimbaSprite: SKSpriteNode!
    var soundComponent: SoundComponent!
    let soundComponentKalimbaSystem = GKComponentSystem(componentClass: SoundComponent.self)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func validationKalimbaKeys(userInputKalimba:String, index:Int) -> Bool{
        print("correct keys" + correctKalimbaKeys[index])
        
        if index == 4 {
            print("congrats you won")

        }
        
        if userInputKalimba.elementsEqual(correctKalimbaKeys[index]){
            return true
        } else {
            return false
        }
    }
    
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
                    print("touch k\(id)")
                    soundComponent.playSound(soundName: "k" + String(id))
                    print(validationKalimbaKeys(userInputKalimba: "k\(id)", index: index))
                    print ("index = \(index)")
                    
                    
                    
                    if validationKalimbaKeys(userInputKalimba: "k\(id)", index: index){
                        userInputKalimbaKeys.append("k\(id)")
                        index = index+1
                    } else {
                        index = 0
                        userInputKalimbaKeys.removeAll()
                    }
                    // Access the associated KalimbaKeyEntity and play the sound
                    
                    
                    print(userInputKalimbaKeys)
                }
            }
        }
    }
}
