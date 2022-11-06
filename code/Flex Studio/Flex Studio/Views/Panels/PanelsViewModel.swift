//
//  PanelsViewModel.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

class PanelsViewModel: ObservableObject {
    private let logger = Logger.forType(PanelsViewModel.self)
    private let viewContext = PersistenceLayer.shared.viewContext
    
    @Published var panels: [Panel] = []
    
    init() {
        fetchPanels()
    }
    
    // MARK: - Data

    private func fetchPanels() {
        let request = Panel.fetchRequestNewestToOldest()
        viewContext.perform {
            do {
                let panels = try self.viewContext.fetch(request)
                self.panels = panels
            } catch {}
        }
    }
    
    func addItem() {
        withAnimation {
            let newPanel = Panel.create(in: viewContext)
            logger.notice("Panel \(newPanel.uid) created!")
            fetchPanels()
        }
    }

    func deleteItem(panel: Panel) {
        withAnimation {
            panel.delete()
            fetchPanels()
        }
    }
    
    // MARK: - UI
    
    let itemColumns = [GridItem(.flexible(), spacing: 20),
                       GridItem(.flexible(), spacing: 20),
                       GridItem(.flexible(), spacing: 20)
    ]
}
