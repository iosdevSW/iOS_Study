//
//  Card.swift
//  SwiftUI_Practice
//
//  Created by iOS신상우 on 2/13/25.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
    var bgColor: Color
}

let cards: [Card] = [
    .init(image: "circle", bgColor: .red),
    .init(image: "circle", bgColor: .blue),
    .init(image: "circle", bgColor: .green),
    .init(image: "circle", bgColor: .yellow)
]
