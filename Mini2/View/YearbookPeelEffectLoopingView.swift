//
//  YearbookPeelEffectLoopingView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 01/07/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct YearbookPeelEffectLoopingView: View {
    @ObservedObject var viewModel = GameData.shared
    @State private var audioPlayer: AVAudioPlayer?
    @State var openedPages: Set<String> = []
    
    var numberOfPages: Int
    var bookType: String
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var flippedXOffset: CGFloat
    var flippedYOffset: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    init(numberOfPages: Int, bookType: String, frameWidth: CGFloat, frameHeight: CGFloat, flippedXOffset: CGFloat, flippedYOffset: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
        self.numberOfPages = numberOfPages
        self.bookType = bookType
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.flippedXOffset = flippedXOffset
        self.flippedYOffset = flippedYOffset
        self.xOffset = xOffset
        self.yOffset = yOffset
    }

    var body: some View {
        ZStack {
            ForEach((1 ..< numberOfPages).reversed(), id: \.self) { pageID in
                if self.openedPages.contains("\(bookType)\(pageID)") {
                    Button {
                        playSound(soundName: "turn yearbook")
                        self.openedPages.remove("\(bookType)\(pageID)")
                    } label: {
                        Image("ML Backpage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth, height: frameHeight)
                            .scaleEffect(x: -1)
                    }
                    .offset(x: flippedXOffset, y: flippedYOffset)
                }
            }
            ForEach((1 ..< numberOfPages).reversed(), id: \.self) { pageID in
                if !self.openedPages.contains("\(bookType)\(pageID)") {
                    HorizontalYearbookPeelEffectView {
                        Image("\(bookType)\(pageID)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth, height: frameHeight)
                            .ignoresSafeArea()
                    } onComplete: {
                        playSound(soundName: "turn yearbook")
                        self.openedPages.insert("\(bookType)\(pageID)")
                        if self.openedPages.count > 2 {
                                viewModel.createInnTot(duration: 3, label: "Why is the bottom of the page peeling off?")
                        }
                    }
                    .offset(x: xOffset, y: yOffset)
                    .zIndex(Double(pageID))
                }
            }
        }
    }
    
    func playSound(soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}
