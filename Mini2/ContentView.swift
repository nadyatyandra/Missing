//
//  File.swift
//  Mini2
//
//  Created by beni garcia on 27/06/23.
//

import Foundation
import SwiftUI
import SpriteKit
import AVFoundation

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
        var popup: SKScene
        if viewModel.popUpName == "JigsawScene"{
            popup = JigsawScene.scene(named: "person.json")
        }
        else {
            popup = SKScene(fileNamed: viewModel.popUpName)!
        }
        popup.backgroundColor = .clear
        popup.scaleMode = .aspectFill
        return popup
    }
    
    var innTot: SKScene {
        let innTot = SKScene(fileNamed: "InnTotScene")! as? InnTotScene
        innTot!.backgroundColor = .clear

        return innTot!
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            if viewModel.isPopUpVisible || viewModel.isSecondPopUpVisible || viewModel.isThirdPopUpVisible || viewModel.isFourthPopUpVisible {
                Button {
                    if viewModel.isFourthPopUpVisible {
                        viewModel.isFourthPopUpVisible = false
                    }
                    else if viewModel.isThirdPopUpVisible {
                        viewModel.isThirdPopUpVisible = false
                        viewModel.isSecondPopUpVisible = false
                    } else if viewModel.isSecondPopUpVisible {
                        viewModel.isSecondPopUpVisible = false
                    } else {
                        viewModel.isPopUpVisible = false
                    }
                    viewModel.isInnTotVisible = false
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
                EmployeeDiaryPeelEffectLoopingView(numberOfPages: 4, bookType: "OL Employee", frameWidth: 520.0, frameHeight: 741.0, flippedXOffset: -250.0, xOffset: 265.0, yOffset: -3.0)
            }
            
            if viewModel.isFourthPopUpVisible { //yearbook animation
                Image("ML Yearbook Base")
                    .resizable()
                    .scaledToFit()
                    .frame(width: scene.size.width/2.5, height: scene.size.height/2.5)
                    .ignoresSafeArea()
                VerticalYearbookPeelEffectView {
                    Image("ML Yearbook Peel Off")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 480.0, height: 730)
                        .ignoresSafeArea()
                } onComplete: {
                    
                }
                .offset(x: 275.0, y: -46.0)
                YearbookPeelEffectLoopingView(numberOfPages: 4, bookType: "ML Yearbook", frameWidth: 483.0, frameHeight: 733.0, flippedXOffset: -190.0, flippedYOffset: -46.0, xOffset: 274.0, yOffset: -44.0)
            }
            
            if viewModel.isInnTotVisible {
                VStack {
                    Spacer()
                    SpriteView(scene: innTot, options: [.allowsTransparency])
                        .frame(width: innTot.size.width, height: innTot.size.height)
                }
                
            }
        }
    }
}
