//
//  DraggableExample.swift
//  SwiftUI_Practice
//
//  Created by iOS신상우 on 7/11/24.
//

import SwiftUI


/*
 dropDestination(for:action:isTargeted:)
 - for: drop을 예상하는 Transferable Model Type
 - action: Drop시에 수행할 동작
 - isTargeted: 커서가 드롭 영역에 들어가거나 나갈때 호출되는 클로저 in: true, out: false
 */

struct DraggableExample: View {
    @State private var isDropSucceed = false
    
    var body: some View {
        VStack {
            if isDropSucceed {
                Color.black.opacity(0.001)
                    .frame(width: 200, height: 200)
                    .overlay {
                        Rectangle()
                            .strokeBorder(style: .init(dash: [4]))
                    }
                    .dropDestination(for: String.self) { items, location in
                        dragProcess(items: items)
                        return true
                    }
            } else {
                Color.red
                    .frame(width: 200, height: 200)
                    .draggable("red") // Transferable
            }
                
            
            Text("DropBox")
                .frame(width: 300, height: 300)
                .background(isDropSucceed ? .red : .clear)
                .border(.black)
                .draggable("backRed") // Transferable
                .dropDestination(for: String.self) { items, location in
                    dragProcess(items: items)
                    return true
                }
        }
    }
}

private extension DraggableExample {
    func dragProcess(items: [String]) {
        withAnimation {
            isDropSucceed.toggle()
        }
    }
}

#Preview {
    DraggableExample()
}


