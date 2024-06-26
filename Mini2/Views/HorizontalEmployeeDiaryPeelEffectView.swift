//
//  HorizontalEmployeeDiaryPeelEffectView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 30/06/23.
//

import SwiftUI

struct HorizontalEmployeeDiaryPeelEffect<Content: View>: View {
    @State private var dragProgress: CGFloat = 0
    var content: Content
    var onComplete: (() -> ())?
    
    init(@ViewBuilder content: @escaping () -> Content, onComplete: @escaping (()->())) {
        self.content = content()
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
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
                                    .padding(.trailing, dragProgress * rect.width)
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
            .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
            .padding(.trailing, rect.width * dragProgress)
            .mask(content)
            .allowsHitTesting(false)
    }
    
    @ViewBuilder
    func glowingSheet() -> some View{
        GeometryReader {
            let size = $0.size
            let minOpacity = dragProgress / 0.05
            let opacity = min(1, minOpacity)
            
            Image("OL Backpage")
                .resizable()
                .scaledToFit()
                .frame(width: 520.0, height: 741.0)
                .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y: 0)
                .scaleEffect(x: -1)
                .offset(x: size.width - (size.width * dragProgress))
                .offset(x: size.width * -dragProgress)
                .mask {
                    Rectangle()
                        .offset(x: size.width * -dragProgress)
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
                    var translationX = value.translation.width
                    translationX = max(-translationX, 0)
                    let progress = min(0.99, translationX / rect.width)
                    dragProgress = progress
                })
                .onEnded({ value in
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        if dragProgress > 0.9 {
                            dragProgress = 0.99
                            if let onComplete {
                                onComplete()
                            }
                        }
                        else {
                            dragProgress = 0.1
                        }
                    }
                })
        )
    }
}
