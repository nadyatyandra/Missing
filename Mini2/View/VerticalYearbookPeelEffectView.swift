//
//  VerticalYearbookPeelEffectView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 30/06/23.
//

import SwiftUI
import AVFoundation

struct VerticalYearbookPeelEffectView<Content: View>: View {
    @ObservedObject var viewModel = GameData.shared
    @State private var dragProgress: CGFloat = 0.1
    @State private var audioPlayer: AVAudioPlayer?
    
    var content: Content
    var onComplete: (() -> ())?
    
    init(@ViewBuilder content: @escaping () -> Content, onComplete: @escaping (()->())) {
        self.content = content()
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack{
            content
                .hidden()
                .overlay(content: {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        insideBoxView(rect: rect)
                        contentShadow(rect: rect)
                        content
                            .mask {
                                Rectangle()
                                    .padding(.bottom, dragProgress * rect.height)
                            }
                            .allowsHitTesting(false)
                    }
                })
                .overlay {
                    glowingSheet()
                }
        }
    }

    @ViewBuilder
    func contentShadow(rect: CGRect) -> some View {
        Rectangle()
            .fill(.black)
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 30)
            .padding(.bottom, rect.height * dragProgress)
            .mask(content)
            .allowsHitTesting(false)
    }
    
    @ViewBuilder
    func glowingSheet() -> some View{
        GeometryReader {
            let size = $0.size
            let minOpacity = dragProgress / 0.05
            let opacity = min(1, minOpacity)
            
            Image("ML Yearbook Peel Off Backpage")
                .resizable()
                .scaledToFit()
                .frame(width: 480.0, height: 730.0)
                .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 0, y: 15)
                .scaleEffect(y: -1)
                .offset(y: size.height - (size.height * dragProgress))
                .offset(y: size.height * -dragProgress)
                .mask {
                    Rectangle()
                        .offset(y: size.height * -dragProgress)
                }
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    func insideBoxView(rect: CGRect) -> some View{
        ZStack {
            Spacer()
                .disabled(dragProgress < 0.9)
        }
        .contentShape(
            Rectangle(), eoFill: true
        )
        .gesture(
            DragGesture()
                .onChanged({ value in
                    var translationY = value.translation.height
                    translationY = max(-translationY, 0)
                    let progress = min(1, translationY / rect.height)
                    dragProgress = progress
                })
                .onEnded({ value in
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        if dragProgress > 0.9 {
                            dragProgress = 0.9
                            playSound(soundName: "turn yearbook")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                viewModel.isPeeled = true
                                if let onComplete {
                                    onComplete()
                                }
                            }
                        }
                        else {
                            dragProgress = 0.1
                        }
                    }
                })
        )
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
