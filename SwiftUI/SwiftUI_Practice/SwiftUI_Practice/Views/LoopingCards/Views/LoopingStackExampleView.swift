//
//  LoopingStackExampleView.swift
//  SwiftUI_Practice
//
//  Created by iOS신상우 on 2/14/25.
//

import SwiftUI

/**
 https://www.youtube.com/watch?v=mEwlTyTtsmE
 */

struct LoopingStackExampleView: View {
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {
                    let width = $0.size.width
                    
                    LoopingStack(maxTranslationWidth: width) {
                        ForEach(cards) { card in
                            card.bgColor
                                .frame(width: 250, height: 400)
                                .clipShape(.rect(cornerRadius: 30))
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 35)
                                        .fill(.background)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Looping Stack")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.2))
        }
    }
}
