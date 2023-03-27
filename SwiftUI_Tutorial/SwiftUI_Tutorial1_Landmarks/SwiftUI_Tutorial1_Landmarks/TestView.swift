//
//  TestView.swift
//  SwiftUI_Tutorial1_Landmarks
//
//  Created by 신상우 on 2023/03/27.
//

import SwiftUI

struct TestView: View {
    @State private var b = 1
    var body: some View {
        Button("testbutton") { b = 2 }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
