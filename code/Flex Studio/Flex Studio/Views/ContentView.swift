//
//  ContentView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import SwiftUI

struct ContentView: View {
    static let logger = Logger.forType(ContentView.self)

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(fetchRequest: Panel.requestNewestToOldest())
    private var panels: FetchedResults<Panel>

    var body: some View {
        NavigationView {
            List {
                ForEach(panels) { panel in
                    NavigationLink {
                        PanelView(panel: panel, selectedTool: .debugDraw, targetSize: .zero)
                    } label: {
                        Text(
                            "Panel from \(panel.creationDate?.toString() ?? Date.nilString)"
                        )
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newPanel = Panel.create(in: viewContext)
            Self.logger.notice("Panel \(newPanel.uid) created!")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets
                .map { panels[$0] }
                .forEach { $0.delete() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
