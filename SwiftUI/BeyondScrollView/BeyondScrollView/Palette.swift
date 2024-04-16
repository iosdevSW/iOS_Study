//
//  Palette.swift
//  BeyondScrollView
//
//  Created by iOS신상우 on 4/16/24.
//

import SwiftUI

// ✅ Hashable한 타입이어야함
struct Palette: Identifiable {
    var id: UUID
    var name: String
    var color: Color
    
    init(id: UUID, color: Color) {
        self.id = id
        self.name = color.description
        self.color = color
    }
}
