//
//  GameData.swift
//  Mini2
//
//  Created by beni garcia on 28/06/23.
//

import Foundation
import SwiftUI
import SpriteKit
import AVFoundation

class GameData : ObservableObject {
    @Published var isPopUpVisible = false //scene
    @Published var isSecondPopUpVisible = false //image
    @Published var isThirdPopUpVisible = false //employee animation
    @Published var isInnTotVisible = false //InnTot
    
    @Published var popUpName = ""
    @Published var imageDetailName = ""
    @Published var animationDetailName = ""
    
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
