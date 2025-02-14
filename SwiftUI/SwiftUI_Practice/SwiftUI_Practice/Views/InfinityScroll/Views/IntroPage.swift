//
//  IntroPage.swift
//  SwiftUI_Practice
//
//  Created by iOS신상우 on 2/13/25.
//

import SwiftUI

struct IntroPage: View {
    /// View Properties
    @State private var activeCard: Card? = cards.first
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    
    
    var body: some View {
        ZStack {
            /// Ambient Background View
            AmbientBackground()
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.0), value: activeCard)
            
            VStack(spacing: 40) {
                InfinityScrollView {
                    ForEach(cards) { card in
                        CarouselCardView(card)
                    }
                }
                .scrollPosition($scrollPosition)
                .scrollIndicators(.hidden)
                .containerRelativeFrame(.vertical) { value, _ in
                    value * 0.45
                }
                .onScrollGeometryChange(for: CGFloat.self) {
                    $0.contentOffset.x + $0.contentInsets.leading
                } action: { oldValue, newValue in
                    currentScrollOffset = newValue
                    let activeIndex = Int((currentScrollOffset / 220).rounded()) % cards.count
                    activeCard = cards[activeIndex]
                }

            }
            .safeAreaPadding(15)
        }
        .onReceive(timer) { _ in
            currentScrollOffset += 0.35
            scrollPosition.scrollTo(x: currentScrollOffset)
            /**
             if you want stop to timer
             timer.upstream.connect().cancel()
             */
        }
    }
    
    @ViewBuilder
    private func AmbientBackground() -> some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(cards) { card in
                    /// You can use downsized image for this, but for the video tutorial purpose, I'm going to use the actual Image!
                    card.bgColor
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                        .frame(width: size.width, height: size.height)
                    /// Only Showing active Card Image
                        .opacity(activeCard?.id == card.id ? 1 : 0)
                }
                
                Rectangle()
                    .fill(.black.opacity(0.45))
                    .ignoresSafeArea()
            }
            .compositingGroup()
            .blur(radius: 9, opaque: true)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func CarouselCardView(_ card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            
            card.bgColor
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: .black.opacity(0.4), radius: 10, x: 1, y: 0)
        }
        .frame(width: 220)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal) {
            content, phase in
            
            content
                .offset(y: phase == .identity ? -10 : 10)
                .rotationEffect(.degrees(phase.value * 5), anchor: .bottom)
        }
    }
}

#Preview {
    IntroPage()
}
