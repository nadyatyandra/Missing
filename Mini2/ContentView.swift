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
    @ObservedObject var viewModel = GameData.shared
    @State var isPopupOn = GameData.shared
    
    var scene: SKScene {
        let scene: SKScene = SKScene(fileNamed: "ModernLibraryScene")!
        scene.size = CGSize(width: 2732, height: 2048)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var popUp: SKScene {
        let popup: SKScene = SKScene(fileNamed: viewModel.popUpName)!
        popup.backgroundColor = .clear
        popup.scaleMode = .aspectFill
        return popup
    }
    
    var innTot: SKScene {
        let innTot: SKScene = SKScene(fileNamed: "InnTotScene")!
        innTot.size = CGSize(width: 2732, height: 2048)
        innTot.backgroundColor = .clear
        innTot.scaleMode = .aspectFill
        return innTot
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            if viewModel.isPopUpVisible || viewModel.isSecondPopUpVisible || viewModel.isThirdPopUpVisible {
                Button {
                    if viewModel.isThirdPopUpVisible {
                        viewModel.isThirdPopUpVisible = false
                        viewModel.isSecondPopUpVisible = false
                    } else if viewModel.isSecondPopUpVisible {
                        viewModel.isSecondPopUpVisible = false
                    } else {
                        viewModel.isPopUpVisible = false
                    }
                } label: {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .ignoresSafeArea()
                }
            }
            
            if viewModel.isPopUpVisible { //scene
                SpriteView(scene: popUp, options: [.allowsTransparency])
                    .frame(width: scene.size.width/2.5, height: scene.size.height/2.5)
                    .ignoresSafeArea()
            }
            
            if viewModel.isSecondPopUpVisible { //image
                Image(viewModel.imageDetailName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: scene.size.width/2.5, height: scene.size.height/2.5)
                    .ignoresSafeArea()
            }
            
            if viewModel.isThirdPopUpVisible { //employee file animation
                PeelEffectLoopingView(numberOfPages: 4, bookType: "OL Employee")
            }
            
            if viewModel.isInnTotVisible {
                SpriteView(scene: innTot, options: [.allowsTransparency])
                    .frame(width: scene.size.width/2.5, height: scene.size.height/2.5)
            }
        }
    }
}
