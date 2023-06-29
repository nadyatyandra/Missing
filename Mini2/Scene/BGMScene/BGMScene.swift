//
//  BGMScene.swift
//  Mini2
//
//  Created by Matthew Togi on 29/06/23.
//

import Foundation
import SpriteKit

import SpriteKit

class BGMScene: SKScene {
    private var backgroundMusic: SKAudioNode?
    
    init(backgroundMusicFileName: String) {
        super.init(size: .zero)
        playBackgroundMusic(fileName: backgroundMusicFileName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func playBackgroundMusic(fileName: String) {
        let musicURL = Bundle.main.url(forResource: fileName, withExtension: "mp3")
        backgroundMusic = SKAudioNode(url: musicURL!)
        addChild(backgroundMusic!)
    }
    
    func pauseBackgroundMusic() {
        backgroundMusic?.isPaused = true
    }
    
    func resumeBackgroundMusic() {
        backgroundMusic?.isPaused = false
    }
}

