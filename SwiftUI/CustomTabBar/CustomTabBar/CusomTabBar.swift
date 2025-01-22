//
//  CusomTabBar.swift
//  CustomTabBar
//
//  Created by iOS신상우 on 1/21/25.
//

import SwiftUI

struct CustomTabBar: View {
    @State var selectedTab: TabItem = .home
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
    }
    
    var displayView: some View {
        switch selectedTab {
        case .home:
            return Color.red.ignoresSafeArea()
        case .search:
            return Color.blue.ignoresSafeArea()
        case .profile:
            return Color.green.ignoresSafeArea()
        case .setting:
            return Color.yellow.ignoresSafeArea()
        }
    }
    
    var tabbar: some View {
        HStack(spacing: .zero) {
            ForEach(TabItem.allCases, id: \.self) { item in
                TabItemButton(item: item, selectedItem: $selectedTab) {
                    selectedTab = $0
                }
            }
        }
        .padding(.bottom, 21)
        .padding(.top, 12)
        .background {
            let screenWidth = UIScreen.main.bounds.width
            let itemWidth = screenWidth/4
            let alpha = ((selectedTab.rawValue * 2)-1)
            let position = (itemWidth/2)/screenWidth * CGFloat(alpha)
            
            CurveShape(radius: 55, depth: 0.95, position: position)
                .fill(backgroundColor)
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "tabbar", in: animation)
        }
    }
}

struct TabItemButton: View {
    let item: TabItem
    @Binding var selectedItem: TabItem
    var didTap: (TabItem) -> Void
    
    @State var offsetY: CGFloat = -5
    
    var body: some View {
        VStack(spacing: 16) {
            item.image
                .offset(y: offsetY)
                .scaleEffect(selectedItem == item ? 1.5 : 1)
            Text(item.title)
                .opacity(selectedItem == item ? 1 : 0)
        }
        .foregroundStyle(Color.black)
        .frame(maxWidth: .infinity)
        .onChange(of: selectedItem, { oldValue, newValue in
            if newValue == item {
                withAnimation(.easeInOut(duration: 0.26)) {
                    offsetY = -17
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.25)) {
                    offsetY = -5
                }
            } else {
                offsetY = -5
            }
        })
        .onTapGesture {
            withAnimation {
                selectedItem = item
            }
        }
    }
}

enum TabItem: Int, CaseIterable {
    case home = 1
    case search = 2
    case profile = 3
    case setting = 4
    
    var image: Image {
        switch self {
        case .home:
                .init(systemName: "house.fill")
        case .search:
                .init(systemName: "magnifyingglass")
        case .profile:
                .init(systemName: "person.crop.circle.fill")
        case .setting:
                .init(systemName: "gearshape.fill")
        }
    }
    
    var title: String {
        switch self {
        case .home:
                "홈"
        case .search:
                "검색"
        case .profile:
                "프로필"
        case .setting:
                "설정"
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .home)
}
