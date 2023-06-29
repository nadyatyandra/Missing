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
    @Published var isPopUpVisible = false //scene
    @Published var isSecondPopUpVisible = false //image
    @Published var isThirdPopUpVisible = false //employee file animation
    
    @Published var popUpName = ""
    @Published var imageDetailName = ""
    @Published var animationDetailName = ""
    
    @Published var lockSprite: SKSpriteNode?
    @Published var lockUnlocked = false
    
    static let shared = GameData()
}

struct ContentView: View {
    @ObservedObject var viewModel = GameData.shared
    @State var isPopupOn = GameData.shared
    @State var openedEmployeePages: Set<String> = []
    var numberOfEmployeePages = 5
    
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
            
            if viewModel.isPopUpVisible || viewModel.isSecondPopUpVisible {
                Button{
                    if viewModel.isPopUpVisible {
                        viewModel.isPopUpVisible = false
                    } else if viewModel.isSecondPopUpVisible {
                        viewModel.isSecondPopUpVisible = false
                    } else {
                        viewModel.isThirdPopUpVisible = false
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
                ZStack {
                    ForEach((1 ..< numberOfEmployeePages).reversed(), id: \.self) { pageID in
                        if self.openedEmployeePages.contains("OL Employee\(pageID)") {
                            Button {
                                self.openedEmployeePages.remove("OL Employee\(pageID)")
                                print(openedEmployeePages)
                            } label: {
                                Image("OL Employee\(pageID))")
                                    .overlay {
                                        Rectangle()
                                            .fill(.white.opacity(0.25))
                                            .mask(Image("OL Employee\(pageID)"))
                                    }
                                    .scaleEffect(x: -1)
                            }
                            .offset(x: -100)
                        }
                    }
                    ForEach((1 ..< numberOfEmployeePages).reversed(), id: \.self) { pageID in
                        if !self.openedEmployeePages.contains("OL Employee\(pageID)") {
                            HorizontalPeelEffect {
                                Image("OL Employee\(pageID)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 550.0, height: 761.0)
                                    .ignoresSafeArea()
                            } onComplete: {
                                self.openedEmployeePages.insert("OL Employee\(pageID)")
                            }
                            .offset(x: 269, y: -11)
                            .zIndex(Double(pageID))
                        }
                    }
                }
            }
        }
    }
}
