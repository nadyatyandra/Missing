//
//  PeelEffectLoopingView.swift
//  Mini2
//
//  Created by Nadya Tyandra on 30/06/23.
//

import Foundation
import SwiftUI

struct PeelEffectLoopingView: View {
    @State var openedPages: Set<String> = []
    var numberOfPages: Int
    var bookType: String

    init(numberOfPages: Int, bookType: String) {
        self.numberOfPages = numberOfPages
        self.bookType = bookType
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
                            .frame(width: 520.0, height: 741.0)
                            .scaleEffect(x: -1)
                    }
                    .offset(x: -250)
                }
            }
            ForEach((1 ..< numberOfPages).reversed(), id: \.self) { pageID in
                if !self.openedPages.contains("\(bookType)\(pageID)") {
                    HorizontalEmployeeDiaryPeelEffect {
                        Image("\(bookType)\(pageID)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 520.0, height: 741.0)
                            .ignoresSafeArea()
                    } onComplete: {
                        self.openedPages.insert("\(bookType)\(pageID)")
                    }
                    .offset(x: 265, y: -3)
                    .zIndex(Double(pageID))
                }
            }
        }
    }
}
