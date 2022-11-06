//
//  PanelsView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct PanelsView: View {
    @StateObject var viewModel = PanelsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.panels) { panel in
                    NavigationLink {
                        PanelView(panel: panel, selectedTool: .debugDraw, targetSize: .zero)
                    } label: {
                        Text(
                            "Panel from \(panel.creationDate?.toString() ?? Date.nilString)"
                        )
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: viewModel.addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
}
