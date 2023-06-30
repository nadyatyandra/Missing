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

class GameData : ObservableObject {
    @Published var isPopUpVisible = false //scene
    @Published var isSecondPopUpVisible = false //image
    @Published var isInnTotVisible = false //InnTot
    
    @Published var popUpName = ""
    
    @Published var imageDetailName = ""
    
    @Published var lockSprite: SKSpriteNode?
    @Published var lockUnlocked = false
    
    @Published var windowSprite: SKSpriteNode?
    
    static let shared = GameData()
    
    func transitionScene(scene: SKScene, toScene: String) {
        let transitionScene = SKScene(fileNamed: toScene)
        transitionScene!.scaleMode = scene.scaleMode
        
        let fadeInAction = SKAction.fadeIn(withDuration: 1.5)
        scene.run(fadeInAction)
        
        let transition = SKTransition.fade(withDuration: 1.5)
        scene.view?.presentScene(transitionScene!, transition: transition)
    }
    
    func playVideo(scene: SKScene,videoName: String, videoExt: String, xPos: Double, durationVideo: Double, toScene: String){
        // Create an AVPlayerItem
        let videoURL = Bundle.main.url(forResource: videoName, withExtension: videoExt)!
        let playerItem = AVPlayerItem(url: videoURL)
        // Create an AVPlayer
        let player = AVPlayer(playerItem: playerItem)
        // Create an SKVideoNode with the AVPlayer
        let videoNode = SKVideoNode(avPlayer: player)
        // Set the video node's size and position
        //        videoNode.size = CGSize(width: 2732, height: 2048)
        videoNode.position = CGPoint(x: xPos, y: 0)
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
}

struct ContentView: View {
    @ObservedObject var viewModel = GameData.shared
    @State var isPopupOn = GameData.shared
    var scene: SKScene {
//        let scene: SKScene = SKScene(fileNamed: "ModernLibraryScene")!
        let scene = JigsawScene.scene(named: "person.json")
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
            
            if viewModel.isPopUpVisible || viewModel.isSecondPopUpVisible {
                Button{
                    if viewModel.isSecondPopUpVisible {
                        viewModel.isSecondPopUpVisible = false
                    }else {
                        viewModel.isPopUpVisible = false
                    }
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
                SpriteView(scene: innTot, options: [.allowsTransparency])
                    .frame(width: scene.size.width/2.5, height: scene.size.height/2.5)
            }
        }
    }
}
