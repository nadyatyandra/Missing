//
//  EmployeeDiaryPeelEffectLoopingView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 30/06/23.
//

import Foundation
import SwiftUI

struct EmployeeDiaryPeelEffectLoopingView: View {
    @State var openedPages: Set<String> = []
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
                        self.openedPages.insert("\(bookType)\(pageID)")
                    }
                    .offset(x: xOffset, y: yOffset)
                    .zIndex(Double(pageID))
                }
            }
        }
    }
}
