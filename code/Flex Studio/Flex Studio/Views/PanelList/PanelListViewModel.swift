//
//  PanelListViewModel.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct PanelListViewModel {
    private let logger = Logger.forType(PanelListViewModel.self)
    private let viewContext = PersistenceLayer.shared.viewContext
    
    // MARK: - Data
    
    func addItem() {
        withAnimation {
            let newPanel = Panel.create(in: viewContext)
            logger.notice("Panel \(newPanel.uid) created!")
        }
    }

    func deleteItem(panel: Panel) {
        withAnimation {
            panel.delete()
        }
    }
    
    // MARK: - UI
    
    let itemColumns = [GridItem(.flexible(), spacing: 32),
                       GridItem(.flexible(), spacing: 32),
                       GridItem(.flexible(), spacing: 32)
    ]
}
