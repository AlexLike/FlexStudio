//
//  PanelsView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import CoreData
import SwiftUI

struct PanelsView: View {
    @FetchRequest(fetchRequest: Panel.fetchRequestOldestToNewest) var panels: FetchedResults<Panel>
    private let viewModel = PanelsViewModel()

    var body: some View {
        ZStack {
            Color.fsBackground.edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: viewModel.itemColumns, spacing: .fsPaddingLarge) {
                    ForEach(panels) { panel in
                        NavigationLink(
                            destination: PanelView(panel: panel, selectedTool: .debugDraw)
                        ) {
                            PanelItemView(panel: panel)
                        }
                        .fsButtonStyleScale()
                    }

                    Button(action: viewModel.addItem) {
                        AddItemView()
                    }
                    .fsButtonStyleScale()
                }
                .padding(.fsPaddingMedium)
                .padding(.bottom, .fsPaddingLarge)
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

    private struct PanelItemView: View {
        @ObservedObject var panel: Panel

        var body: some View {
            VStack(spacing: .fsPaddingMedium) {
                Color.clear // TODO: - Image Snapshot of Panel
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
                        VStack(spacing: .fsPaddingSmall) {
                            Image.fsPaint
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
