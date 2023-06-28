//
//  PuzzleLock.swift
//  Mini2
//
//  Created by beni garcia on 21/06/23.
//

import SpriteKit
import SwiftUI

class LockScene: SKScene{
    @ObservedObject var viewModel = GameData.shared
    var lockNumbers: [SKSpriteNode] = []
    var arrowUpLocks: [SKSpriteNode] = []
    var arrowDownLocks: [SKSpriteNode] = []
    var confirmLock: SKSpriteNode?
    var bgLock: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        for i in 0..<4 {
            let lockNumber = childNode(withName: "lockNumber\(i)") as? SKSpriteNode
            let arrowUpLock = childNode(withName: "arrowUpLock\(i)") as? SKSpriteNode
            let arrowDownLock = childNode(withName: "arrowDownLock\(i)") as? SKSpriteNode
            
            lockNumbers.append(lockNumber!)
            arrowUpLocks.append(arrowUpLock!)
            arrowDownLocks.append(arrowDownLock!)
        }
        confirmLock = childNode(withName: "confirmLock") as? SKSpriteNode
        bgLock = childNode(withName: "bg_lock") as? SKSpriteNode
        bgLock?.color = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for i in 0..<4{
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == arrowUpLocks[i] {
                    
                    for j in 0..<10{
                        if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "number9"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "number0")
                            break
                        }else if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "number\(j)"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "number\(j+1)")
                            break
                        }
                    }
                }
            }
            
            for i in 0..<4{
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == arrowDownLocks[i] {
                    for j in 0..<10{
                        if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "number0"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "number9")
                            break
                        }else if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "number\(j)"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "number\(j-1)")
                            break
                        }
                    }
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == confirmLock {
                if(lockNumbers[0].texture?.description.components(separatedBy: "'")[1] == "number9" && lockNumbers[1].texture?.description.components(separatedBy: "'")[1] == "number9" && lockNumbers[2].texture?.description.components(separatedBy: "'")[1] == "number9" && lockNumbers[3].texture?.description.components(separatedBy: "'")[1] == "number9" ){
                    print("success")
                    
                    viewModel.isPopUpVisible = false
                }else{
                    print("gagal")
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == bgLock {
                viewModel.isPopUpVisible = false
            }
        }
    }
    
}
