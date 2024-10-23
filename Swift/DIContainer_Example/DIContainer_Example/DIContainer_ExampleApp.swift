//
//  DIContainer_ExampleApp.swift
//  DIContainer_Example
//
//  Created by iOS신상우 on 10/23/24.
//

import SwiftUI

@main
struct DIContainer_ExampleApp: App {
    
    // MARK: - DI
    init() {
        DependencyBox.live
            .register(Userable.self) {
                User(name: "상우", age: 27)
            }
            .register(Userable.self) {
                User(name: "동우", age: 20)
            }
            .register(Userable.self, name: "태그1") {
                User(name: "소우", age: 23)
            }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(dependencyBox: .live)
        }
    }
}
