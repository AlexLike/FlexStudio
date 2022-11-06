//
//  MainNavigationView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct MainNavigationView: View {
    
    var body: some View {
        NavigationStack {
            PanelsView()
        }
        .tint(.fs_black) // Global tint
    }
}
