//
//  EmployeeDiaryPeelEffectLoopingView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 30/06/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct EmployeeDiaryPeelEffectLoopingView: View {
    @State var openedPages: Set<String> = []
    @State private var audioPlayer: AVAudioPlayer?
    
    var numberOfPages: Int
    var bookType: String
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var flippedXOffset: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat

    init(numberOfPages: Int, bookType: String, frameWidth: CGFloat, frameHeight: CGFloat, flippedXOffset: CGFloat, xOffset: CGFloat, yOffset: CGFloat) {
        self.numberOfPages = numberOfPages
        self.bookType = bookType
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.flippedXOffset = flippedXOffset
        self.xOffset = xOffset
        self.yOffset = yOffset
    }

    var body: some View {
        ZStack {
            ForEach((1 ..< numberOfPages).reversed(), id: \.self) { pageID in
                if self.openedPages.contains("\(bookType)\(pageID)") {
                    Button {
                        playSound(soundName: "turn diary")
                        self.openedPages.remove("\(bookType)\(pageID)")
                    } label: {
                        Image("OL Backpage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth, height: frameHeight)
                            .scaleEffect(x: -1)
                    }
                    .offset(x: flippedXOffset)
                }
            }
            ForEach((1 ..< numberOfPages).reversed(), id: \.self) { pageID in
                if !self.openedPages.contains("\(bookType)\(pageID)") {
                    HorizontalEmployeeDiaryPeelEffectView {
                        Image("\(bookType)\(pageID)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: frameWidth, height: frameHeight)
                            .ignoresSafeArea()
                    } onComplete: {
                        playSound(soundName: "turn diary")
                        self.openedPages.insert("\(bookType)\(pageID)")
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
