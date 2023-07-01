//
//  YearbookPeelEffectLoopingView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 01/07/23.
//

import Foundation
import SwiftUI

struct YearbookPeelEffectLoopingView: View {
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
                        self.openedPages.insert("\(bookType)\(pageID)")
                    }
                    .offset(x: xOffset, y: yOffset)
                    .zIndex(Double(pageID))
                }
            }
        }
    }
}
