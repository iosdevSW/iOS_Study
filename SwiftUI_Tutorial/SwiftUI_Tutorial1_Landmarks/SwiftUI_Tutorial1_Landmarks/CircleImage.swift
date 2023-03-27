//
//  CircleImage.swift
//  SwiftUI_Tutorial1_Landmarks
//
//  Created by 신상우 on 2023/03/27.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay { Circle().stroke(.white, lineWidth: 4) }
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
