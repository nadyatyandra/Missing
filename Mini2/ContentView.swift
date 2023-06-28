//
//  File.swift
//  Mini2
//
//  Created by beni garcia on 27/06/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var isPopUpVisible : Bool = false
    
    var scene: SKScene {
        let scene: SKScene = SKScene(fileNamed: "CorridorScene")!
        
        scene.size = CGSize(width: 2732, height: 2048)
        scene.scaleMode = .aspectFit
        
        return scene
    }
    
    var popUp: SKScene {
        let popup: SKScene = SKScene(fileNamed: "LockScene")!
        popup.size = CGSize(width: 1920, height: 1080)
        popup.scaleMode = .aspectFit
        
        return popup
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            if isPopUpVisible {
                SpriteView(scene: popUp)
                    .frame(width: 500, height: 300)
            }
        }
        
    }
}
