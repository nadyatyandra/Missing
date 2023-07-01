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
    @Published var isThirdPopUpVisible = false //employee file animation
    @Published var isFourthPopUpVisible = false //yearbook animation
    @Published var isFifthPopUpVisible = false //diary animation
    @Published var isInnTotVisible = false //InnTot
    @Published var isPeeled = false
    @Published var isMove = true
    
    
    @Published var popUpName = ""
    @Published var imageDetailName = ""
    @Published var animationDetailName = ""
    
    @Published var enemySprite: SKSpriteNode?
    
    @Published var lockSprite: SKSpriteNode?
    @Published var lockUnlocked = false
    
    @Published var windowSprite: SKSpriteNode?
    
    @Published var innTotText: String = ""
    @Published var innTotDuration: Double = 1
    
    @Published var kalimbaSolved: Bool = false
    
    static let shared = GameData()
    
    func closePopUp(){
        if isThirdPopUpVisible{
            isThirdPopUpVisible = false
            isSecondPopUpVisible = false
        }else if isSecondPopUpVisible{
            isSecondPopUpVisible = false
        }else if isPopUpVisible{
            isPopUpVisible = false
        }
    }
    
    func transitionScene(scene: SKScene, toScene: String) {
        closePopUp()
        let transitionScene = SKScene(fileNamed: toScene)
        transitionScene!.scaleMode = scene.scaleMode

        let transition = SKTransition.fade(with: UIColor.black, duration: 3)
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
        videoNode.size = CGSize(width: 2732, height: 2048)
        videoNode.position = CGPoint(x: xPos, y: yPos)
        videoNode.zPosition = 2
        
        // Add the video node to the scene
        scene.addChild(videoNode)
        self.isMove = false
        // Play the video
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + durationVideo) {
            videoNode.removeFromParent()
            self.transitionScene(scene: scene, toScene: toScene)
            self.isMove = true
        }
    }
    
    func createInnTot(duration: Double, label: String) {
        innTotText = label
        innTotDuration = duration
        
        DispatchQueue.main.async {
            if self.isInnTotVisible {
                self.isInnTotVisible = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.isInnTotVisible = true
                }
            } else {
                self.isInnTotVisible = true
            }
        }
        
    }
}
