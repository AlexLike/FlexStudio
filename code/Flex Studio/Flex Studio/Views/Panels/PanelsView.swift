//
//  PanelsView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import CoreData
import SwiftUI

struct PanelsView: View {
    @Environment(\.managedObjectContext) var viewContext: NSManagedObjectContext
    @FetchRequest(fetchRequest: Panel.fetchRequestOldestToNewest) var panels: FetchedResults<Panel>

    var body: some View {
        ZStack {
            Color.fsBackground.edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: .fs_padding_large) {
                    ForEach(panels) { panel in
                        NavigationLink(
                            destination: PanelView(panel: panel, selectedTool: .debugDraw,
                                                   targetSize: .zero)
                        ) {
                            PanelItemView(panel: panel)
                        }
                        .fs_buttonStyleScale()
                    }

                    Button(action: addPanel) {
                        AddItemView()
                    }
                    .fs_buttonStyleScale()
                }
                .padding(.fs_padding_medium)
                .padding(.bottom, .fs_padding_large)
            }
        }
        .navigationTitle("Panels")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Text("Select") // TODO: - Implement selecting logic
                }
            }
        }
    }

    let columns = [GridItem(.flexible(), spacing: 20),
                   GridItem(.flexible(), spacing: 20),
                   GridItem(.flexible(), spacing: 20)]

    func addPanel() {
        Panel.create(in: viewContext)
    }

    private struct PanelItemView: View {
        @ObservedObject var panel: Panel

        var body: some View {
            VStack(spacing: .fs_padding_medium) {
                Color.gray.opacity(0.1) // TODO: - Image Snapshot of Panel
                    .background(Color.fsWhite)
                    .frame(height: 240) // TODO: - Dynamic height based on Panel
                    .cornerRadius(10)

                // TODO: - Number in Comic (in final product)
                Text("\(panel.creationDate?.toString() ?? Date.nilString)")
                    .font(.fsSubtitle)
                    .foregroundColor(.gray)
            }
        }
    }

    private struct AddItemView: View {
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.fsGray, style: StrokeStyle(lineWidth: 4, dash: [15.0]))
                    .frame(height: 240)
                    .cornerRadius(10)
                    .overlay(
                        VStack(spacing: .fs_padding_small) {
                            Image.fs_paint
                                .font(.system(size: 32))
                                .foregroundColor(.fsGray)
                            Text("New panel")
                                .font(.fsSubtitle)
                                .foregroundColor(.fsGray)
                        }
                    )

                Spacer()
            }
        }
    }
}

struct PanelsView_Previews: PreviewProvider {
    static var previews: some View {
        PanelsView()
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
