//
//  CenterTabBar.swift
//  CustomTabBar
//
//  Created by iOS신상우 on 1/23/25.
//

import SwiftUI

struct ElevatedTabBar: View {
    @State var selectedTab: ElevatedTabItem = .home
    @Namespace var animation
    var backgroundColor: Color = .white
    
    var body: some View {
        ZStack {
            displayView
            VStack(spacing: .zero) {
                Spacer(minLength: .zero)
                tabbar
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
//        .animation(.spring, value: selectedTab)
    }
    
    var displayView: some View {
        switch selectedTab {
        case .home:
            return Color.red.ignoresSafeArea()
        case .search:
            return Color.blue.ignoresSafeArea()
        case .floating:
            return Color.clear.ignoresSafeArea()
        case .profile:
            return Color.green.ignoresSafeArea()
        case .setting:
            return Color.yellow.ignoresSafeArea()
        }
    }
    
    var tabbar: some View {
        VStack(alignment: .center) {
            HStack(spacing: .zero) {
                ForEach(ElevatedTabItem.allCases, id: \.self) { item in
                    ElevatedTabItemButton(item: item, isSelected: item == selectedTab) {
                        selectedTab = $0
                    }
                    .disabled(item == .floating)
                }
            }
        }
        .frame(height: 74)
        .overlay {
            Button {
                
            } label: {
                Image(systemName: "folder")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .padding(15)
                    .background(LinearGradient(
                        stops: [
                        Gradient.Stop(color: .black, location: 0.00),
                        Gradient.Stop(color: Color(red: 0.25, green: 0.27, blue: 0.29), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: -0.01, y: 0),
                        endPoint: UnitPoint(x: 0.99, y: 1)
                        )
                    )
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4)
            }
        }
        .padding(.bottom, 21)
        .background { backgroundColor }
        .clipShape(UnevenRoundedRectangle(
            topLeadingRadius: 32,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 32
        ))
        .shadow(color: Color(red: 0.4, green: 0.42, blue: 0.51).opacity(0.05), radius: 8, x: 0, y: -10)
    }
}

struct ElevatedTabItemButton: View {
    let item: ElevatedTabItem
    var isSelected: Bool
    var didTap: (ElevatedTabItem) -> Void
    
    @State var pointScale = 1.0
    @State var offsetY: CGFloat = -5
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .frame(width: 4, height: 4)
                .opacity(isSelected ? 1 : 0)
                .scaleEffect(pointScale)
                .animation(.interpolatingSpring, value: isSelected)
            
            item.image
                .resizable()
                .frame(width: 24, height: 24)
                .frame(maxWidth: .infinity)
                .foregroundStyle(isSelected ? .black : .gray)
        }
        .foregroundStyle(Color.black)
        .frame(maxWidth: .infinity)
        .onChange(of: isSelected, { oldValue, newValue in
            if isSelected {
                withAnimation(.easeInOut(duration: 0.26)) {
                    pointScale = 1.3
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.25)) {
                    pointScale = 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.5)) {
                    pointScale = 0.0001
                }
            }
        })
        .onTapGesture {
            withAnimation {
                didTap(item)
            }
        }
    }
}

enum ElevatedTabItem: Int, CaseIterable {
    case home = 1
    case search = 2
    case floating = 3
    case profile = 4
    case setting = 5
    
    var image: Image {
        switch self {
        case .home:
                .init(systemName: "house")
        case .search:
                .init(systemName: "magnifyingglass")
        case .floating:
                .init("")
        case .profile:
                .init(systemName: "person.crop.circle")
        case .setting:
                .init(systemName: "gearshape")
        }
    }
    
    var title: String {
        switch self {
        case .home:
                "홈"
        case .search:
                "검색"
        case .floating:
                ""
        case .profile:
                "프로필"
        case .setting:
                "설정"
        }
    }
}

#Preview {
    ElevatedTabBar(selectedTab: .home, backgroundColor: .white)
}
