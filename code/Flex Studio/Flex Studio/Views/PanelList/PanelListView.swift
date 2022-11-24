//
//  PanelListView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import CoreData
import SwiftUI

struct PanelListView: View {
    @FetchRequest(fetchRequest: Panel.fetchRequestOldestToNewest) var panels: FetchedResults<Panel>
    private let viewModel = PanelListViewModel()
    @State private var onDelete: (show: Bool, panel: Panel?) = (false, nil)

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: viewModel.itemColumns, spacing: 24) {
                    ForEach(panels) { panel in
                        PanelListCell(panel: panel)
                    }

                    Button(action: viewModel.addItem) {
                        AddItemView()
                    }
                    .buttonStyle(.scaleReactive(factor: 1.05))
                }
                .padding(24)
                .padding(.bottom, 32)

                VStack(spacing: 8) {
                    HStack {
                        Text("Made with")
                        Image(systemName: "heart.fill")
                            .foregroundColor(.pink)
                            .fixedSize()
                            .frame(height: 0)
                        Text("in Zürich for Human-Computer Interaction, HS22")
                    }

                    Image("siplab-ait-eth-logos")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 48)
                        .padding()

                    HStack(spacing: 16) {
                        ForEach(
                            ["Kai Zheng", "Cashen Adkins", "Tim Kluser", "Karl Robert Kristenprun",
                             "Alexander Zank"],
                            id: \.self
                        ) {
                            Text($0)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Panels")
        .overlay(
            DatabaseDebugView()
        )
        .alert("Delete", isPresented: $onDelete.show, actions: {
            Button("Delete", action: {
                if let panel = onDelete.panel {
                    viewModel.deleteItem(panel: panel)
                }
            })
            Button("Cancel", role: .cancel, action: {})
        })
    }

    private struct AddItemView: View {
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 32)
                    .inset(by: 2)
                    .stroke(Color.tertiary, style: StrokeStyle(lineWidth: 2, dash: [15.0]))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.tertiary)
                            Text("New Panel")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.tertiary)
                        }
                    )

                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

struct PanelsView_Previews: PreviewProvider {
    static var previews: some View {
        PanelListView()
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
