//
//  PeelOffScene.swift
//  Mini2
//
//  Created by Nadya Tyandra on 25/06/23.
//

import Foundation
import SpriteKit
import UIKit

class PeelOffScene: SKScene {
    var page = SKSpriteNode()
    var peel = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        page = SKSpriteNode(imageNamed: "page")
        page.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        page.position = CGPoint(x: 0, y: 0)
        page.setScale(2.5)
        page.zPosition = -1
        
        peel = SKSpriteNode(imageNamed: "peel")
        peel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        peel.position = CGPoint(x: 355, y: 400)
        peel.setScale(1.0)
        
//        print("x: \(peel.position.x), y: \(peel.position.y )")
        
        addChild(page)
        addChild(peel)
    }
    
    func validatePeelOff(xEndPoint: CGFloat, yEndPoint: CGFloat) -> Bool {
        if (xEndPoint <= -700 && xEndPoint >= -800) && (yEndPoint <= -700 && yEndPoint >= -800) {
            return true
        }
        return false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            peel.position.x = location.x
            peel.position.y = location.y
            
//            peel.anchorPoint = CGPoint(x: 0, y: 0)
            
//            print("x: \(peel.position.x), y: \(peel.position.y)")
            
            if validatePeelOff(xEndPoint: peel.position.x, yEndPoint: peel.position.y) {
                print("peeled at x: \(peel.position.x), y: \(peel.position.y)")
            }
            else {
                print("x: \(peel.position.x), y: \(peel.position.y)")
            }
        }
    }
}
