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
    @State private var onDelete: (show: Bool, panel: Panel?) = (false, nil)

    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: viewModel.itemColumns, spacing: 32) {
                    ForEach(panels) { panel in
                        NavigationLink(
                            destination: EditorView(panel: panel)
                        ) {
                            PanelItemView(panel: panel, viewModel: viewModel)
                        }
                        .buttonStyle(.scaleReactive(factor: 1.05))
                    }
 

                    Button(action: viewModel.addItem) {
                        AddItemView(viewModel: viewModel)
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
                        Text("in Zürich for")
                    }
                    HStack {
                        Image("siplab-logo")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140)
                        Image("ait-logo")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                    }
                    .padding(.top)
                    Image("eth-logo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(.bottom)
                    
                    HStack(spacing: 16) {
                        ForEach(["Kai Zheng", "Cashen Adkins", "Tim Kluser", "Karl Robert Kristenprun", "Alexander Zank"], id: \.self) {
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

    private struct PanelItemView: View {
        @ObservedObject var panel: Panel
        var viewModel: PanelsViewModel

        var body: some View {
            VStack(spacing: 24) {
                Image(uiImage: panel.previewImage ?? UIImage())
                    .resizable()
                    .aspectRatio(.init(width: 1.0, height: 1.0), contentMode: .fit)
                    .background(Color.white)
                    .cornerRadius(10)
                    .clipped()

                // TODO: - Number in Comic (in final product)
                Text("\(panel.creationDate?.toString() ?? Date.nilString)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }

    private struct AddItemView: View {
        var viewModel: PanelsViewModel
        
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.tertiary, style: StrokeStyle(lineWidth: 4, dash: [15.0]))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.tertiary)
                            Text("New panel")
                                .font(.subheadline)
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
        PanelsView()
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}


