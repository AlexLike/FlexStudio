//
//  MainNavigationView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct MainNavigationView: View {
    @State private var safeAreaInsets: (top: CGFloat, bottom: CGFloat) = (0, 0)
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    Color.clear.onAppear { safeAreaInsets = (proxy.safeAreaInsets.top, proxy.safeAreaInsets.bottom) }
                }
                
                PanelsView()
                    .environment(\.safeAreaInsets, safeAreaInsets)
            }
        }
        .tint(.fsBlack)
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
