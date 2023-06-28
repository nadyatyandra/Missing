//
//  File.swift
//  Mini2
//
//  Created by beni garcia on 27/06/23.
//

import Foundation
import SwiftUI
import SpriteKit

class GameData : ObservableObject {
    @Published var isPopUpVisible = false
    @Published var popUpName = ""
    static let shared = GameData()
}

struct ContentView: View {
    @ObservedObject var viewModel = GameData.shared
    @State var isPopupOn = GameData.shared
    var scene: SKScene {
        let scene: SKScene = SKScene(fileNamed: "PlaytestScreen")!
        scene.size = CGSize(width: 2732, height: 2048)
        scene.scaleMode = .aspectFit
        return scene
    }
    
    var popUp: SKScene {
        let popup: SKScene = SKScene(fileNamed: viewModel.popUpName)!
        popup.size = CGSize(width: 2732, height: 2048)
        popup.backgroundColor = .clear
        popup.scaleMode = .aspectFit
        
        return popup
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            if viewModel.isPopUpVisible {
                Button{
                    viewModel.isPopUpVisible = false
                }label: {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .ignoresSafeArea()
                }
            }
            
            if viewModel.isPopUpVisible {
                SpriteView(scene: popUp, options: [.allowsTransparency])
                    .frame(width: scene.size.width/3, height: scene.size.height/3)
                    .ignoresSafeArea()
            }
            
            
        }
    }
}
