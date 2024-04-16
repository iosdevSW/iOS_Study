//
//  ContentView.swift
//  BeyondScrollView
//
//  Created by iOS신상우 on 4/16/24.
//

import SwiftUI

struct ContentView: View {
    let hSpacing: CGFloat = 16
    let hMargin: CGFloat = 16
    
    let palettes = [
        Palette.init(id: UUID(), color: .blue),
        Palette.init(id: UUID(), color: .red),
        Palette.init(id: UUID(), color: .green),
        Palette.init(id: UUID(), color: .black),
    ]
    
    @State private var mainID: Palette.ID?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: hSpacing) {
                ForEach(palettes, id: \.id) { palette in
                    palette.color
                        .aspectRatio(4.0/3.0, contentMode: .fit)
                        .containerRelativeFrame(.horizontal)
                }
                .scrollTransition(axis: .horizontal) { content, phase in
                    content
                        .scaleEffect(
                            x: phase.isIdentity ? 1.0 : 0.80,
                            y: phase.isIdentity ? 1.0 : 0.80)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(hMargin , for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $mainID)
        
        Button {
            scrollToPreviousID()
        } label: {
            Text("이전")
        }
    }
    
    private func scrollToPreviousID() {
        guard let id = mainID, id != palettes.first?.id,
              let index = palettes.firstIndex(where: { $0.id == id })
        else { return }
        
        
        withAnimation {
            mainID = palettes[index-1].id
        }
    }
}

#Preview {
    ContentView()
}
