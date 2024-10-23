//
//  ContentView.swift
//  DIContainer_Example
//
//  Created by iOS신상우 on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    
    let dependencyBox: DependencyBox
    
    init(dependencyBox: DependencyBox) {
        self.dependencyBox = dependencyBox
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("IOC Container Example")
            Button {
                print(user)
                print(user2)
                print("🚧🚧🚧🚧🚧🚧🚧")
                
            } label: {
                Text("Print Depedency Box Info")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Dependecy Resolve
extension ContentView {
    var user: Userable {
        dependencyBox.resolve()
    }
    
    var user2: Userable {
        dependencyBox.resolve(name: "태그1")
    }
}

#Preview {
    ContentView(dependencyBox: .live)
}
