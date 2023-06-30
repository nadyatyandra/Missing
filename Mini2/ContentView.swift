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
    @Published var isInnTotVisible = false //InnTot
    
    @Published var popUpName = ""
    
    @Published var imageDetailName = ""
    
    @Published var lockSprite: SKSpriteNode?
    @Published var lockUnlocked = false
    
    @Published var windowSprite: SKSpriteNode?
    
    @Published var innTotText: String = ""
    @Published var innTotDuration: Double = 1
    
    static let shared = GameData()
<<<<<<< Updated upstream
=======
    
    func transitionScene(scene: SKScene, toScene: String) {
        let transitionScene = SKScene(fileNamed: toScene)
        transitionScene!.scaleMode = scene.scaleMode
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1.5)
        scene.run(fadeInAction)
        
        let transition = SKTransition.fade(withDuration: 1.5)
        scene.view?.presentScene(transitionScene!, transition: transition)
    }
    
    func playVideo(scene: SKScene,videoName: String, videoExt: String, xPos: Double, yPos: Double, durationVideo: Double, toScene: String){
        // Create an AVPlayerItem
        let videoURL = Bundle.main.url(forResource: videoName, withExtension: videoExt)!
        let playerItem = AVPlayerItem(url: videoURL)
        // Create an AVPlayer
        let player = AVPlayer(playerItem: playerItem)
        // Create an SKVideoNode with the AVPlayer
        let videoNode = SKVideoNode(avPlayer: player)
        // Set the video node's size and position
        //        videoNode.size = CGSize(width: 2732, height: 2048)
        videoNode.position = CGPoint(x: xPos, y: yPos)
        videoNode.zPosition = 2
        
        // Add the video node to the scene
        scene.addChild(videoNode)
        // Play the video
        
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + durationVideo) {
            videoNode.removeFromParent()
            self.transitionScene(scene: scene, toScene: toScene)
        }
        
        
    }
    
    func createInnTot(duration: Double, label: String) {
        innTotText = label
        innTotDuration = duration
        
        if isInnTotVisible {
            isInnTotVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isInnTotVisible = true
            }
        } else {
            isInnTotVisible = true
        }
    }
>>>>>>> Stashed changes
}


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
        let innTot = SKScene(fileNamed: "InnTotScene")! as? InnTotScene
        innTot!.backgroundColor = .clear

        return innTot!
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            if viewModel.isPopUpVisible || viewModel.isSecondPopUpVisible {
                Button{
                    if viewModel.isSecondPopUpVisible {
                        viewModel.isSecondPopUpVisible = false
                    }else {
                        viewModel.isPopUpVisible = false
                    }
                    viewModel.isInnTotVisible = false
                }label: {
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
            
            if viewModel.isInnTotVisible {
                VStack {
                    Spacer()
//                    SpriteView(scene: viewModel.innTot, options: [.allowsTransparency])
//                        .frame(width: viewModel.innTot.size.width, height: viewModel.innTot.size.height)
                    SpriteView(scene: innTot, options: [.allowsTransparency])
                        .frame(width: innTot.size.width, height: innTot.size.height)
                }
                
            }
        }
    }
}
