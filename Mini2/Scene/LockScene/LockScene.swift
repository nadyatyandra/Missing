//
//  PuzzleLock.swift
//  Mini2
//
//  Created by beni garcia on 21/06/23.
//

import SpriteKit

class LockScene: SKScene{
    
    var lockNumbers: [SKSpriteNode] = []
    var arrowUpLocks: [SKSpriteNode] = []
    var arrowDownLocks: [SKSpriteNode] = []
    var confirmLock: SKSpriteNode?
    
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            for i in 0..<4{
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == arrowUpLocks[i] {
                    
                    for j in 0..<10{
                        if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "lock9"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "lock0")
                            break
                        }else if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "lock\(j)"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "lock\(j+1)")
                            break
                        }
                    }
                }
            }
            
            for i in 0..<4{
                if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == arrowDownLocks[i] {
                    for j in 0..<10{
                        if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "lock0"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "lock9")
                            break
                        }else if lockNumbers[i].texture?.description.components(separatedBy: "'")[1] == "lock\(j)"{
                            lockNumbers[i].texture = SKTexture(imageNamed: "lock\(j-1)")
                            break
                        }
                    }
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode, touchedNode == confirmLock {
                if(lockNumbers[0].texture?.description.components(separatedBy: "'")[1] == "lock9" && lockNumbers[1].texture?.description.components(separatedBy: "'")[1] == "lock9" && lockNumbers[2].texture?.description.components(separatedBy: "'")[1] == "lock9" && lockNumbers[3].texture?.description.components(separatedBy: "'")[1] == "lock9" ){
                    print("success")
                    
                    let playScene = SKScene(fileNamed: "PlaytestScreen")
                    playScene?.scaleMode = .aspectFit
                    self.view?.presentScene(playScene)
                }else{
                    print("gagal")
                }
            }
        }
    }
    
}
