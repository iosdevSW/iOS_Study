//
//  SwiftUI_Tutorial1_LandmarksApp.swift
//  SwiftUI_Tutorial1_Landmarks
//
//  Created by 신상우 on 2023/03/27.
//

import SwiftUI

@main
struct SwiftUI_Tutorial1_LandmarksApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
//                .background(Color.brown)
//            TestView()
//                .background(Color.yellow)
        }
    }
}
