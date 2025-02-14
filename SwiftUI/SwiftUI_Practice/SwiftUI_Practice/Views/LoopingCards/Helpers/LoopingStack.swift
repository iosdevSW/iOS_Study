//
//  LoopingStack.swift
//  SwiftUI_Practice
//
//  Created by iOS신상우 on 2/14/25.
//

import SwiftUI

struct LoopingStack<Content: View>: View {
    var visibleCardsCount = 1
    var maxTranslationWidth: CGFloat?
    
    @State private var rotation: Int = 0
    
    @ViewBuilder var content: Content
    
    var body: some View {
        /// Starting with iOS 18 we can exract Subview collection from a view content with the help of Group
        Group(subviews: content) { collection in
            let collection = collection.rotateFromLeft(by: rotation)
            let count = collection.count
            
            ZStack {
                ForEach(collection) { view in
                    /// Let's reverse the stack ZIndex
                    let index = collection.index(view)
                    let zIndex = Double(count - index)
                    
                    LooopingStackCardView(
                        index: index,
                        count: count,
                        visibleCardsCount: visibleCardsCount,
                        maxTranslationWidth: maxTranslationWidth,
                        rotation: $rotation
                    ) {
                        view
                    }
                    .zIndex(zIndex)
                }
            }
        }
    }
}

/// Let's Create a Custom View for each card view, so that it maintains offset for each individual cards
fileprivate struct LooopingStackCardView<Content: View>: View {
    var index: Int
    var count: Int
    var visibleCardsCount: Int
    var maxTranslationWidth: CGFloat?
    
    @State private var offset: CGFloat = .zero
    /// UseFul to calculate the and result when dragging is finished (to push into the next card)
    @State private var viewSize: CGSize = .zero
    
    @Binding var rotation: Int
    
    @ViewBuilder var content: Content
    
    var body: some View {
        /// Visible Cards Offset and Scaling
        /// You can even customize this to suit your own requirements
        let extraOffset = min(CGFloat(index) * 20, CGFloat(visibleCardsCount) * 20)
        let scale = 1 - min(CGFloat(index) * 0.07, CGFloat(visibleCardsCount) * 0.07)
        /// Now, let's have some 3D rotation when swiping the card
        let rotationDegree: CGFloat = -30
        let rotation = (max(min(-offset / viewSize.width, 1), 0) * rotationDegree)
        
        content
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: {
                viewSize = $0
            })
            .offset(x: extraOffset)
            .scaleEffect(scale, anchor: .trailing)
            .animation(.smooth(duration: 0.25, extraBounce: 0), value: index)
            .offset(x: offset)
            .rotation3DEffect(.init(degrees: rotation), axis: (0, 1, 0), anchor: .center, perspective: 0.5)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let xOffset = -max(-value.translation.width, 0)
                        if let maxTranslationWidth {
                            let progress = max(min(xOffset / maxTranslationWidth, 1), 0) * viewSize.width
                            offset = progress
                        } else {
                            offset = xOffset
                        }
                    }
                    .onEnded { value in
                        let xVelocity = max(-value.velocity.width / 5, 0)
                        
                        if (-offset + xVelocity) > (viewSize.width * 0.65) {
                            pushToNextCard()
                        } else {
                            withAnimation(.smooth(duration: 0.3, extraBounce: 0)) {
                                offset = .zero
                            }
                        }
                    },
                isEnabled: index == 0 && count > 1
            )
    }
    
    private func pushToNextCard() {
        withAnimation(.smooth(duration: 0.25, extraBounce: 0).logicallyComplete(after: 0.15), completionCriteria: .logicallyComplete) {
            offset = -viewSize.width
        } completion: {
            rotation += 1
            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                offset = .zero
            }
        }
    }
}

extension SubviewsCollection {
    /// Now, to push cards behind when it's swiped and to make it appear as if it's looping, we can actually rotate the array to achieve that
    func rotateFromLeft(by: Int) -> [SubviewsCollection.Element] {
        let moveIndex = by % count
        let rotateElements = Array(self[moveIndex...]) + Array(self[0..<moveIndex])
        
        return rotateElements
    }
    
    
    
}
extension [SubviewsCollection.Element] {
    func index(_ item: SubviewsCollection.Element) -> Int {
        firstIndex(where: { $0.id == item.id }) ?? 0
    }
}

#Preview {
    LoopingStackExampleView()
}
