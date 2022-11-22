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
            Color.fsBackground.edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: viewModel.itemColumns, spacing: .fsPaddingLarge) {
                    ForEach(panels) { panel in
                        NavigationLink(
                            destination: EditorView(panel: panel)
                        ) {
                            PanelItemView(panel: panel, viewModel: viewModel)
//                                .highPriorityGesture(LongPressGesture().onEnded { _ in
//                                    onDelete = (true, panel)
//                                })
                        }
                        .buttonStyle(.scaleReactive(factor: 1.05))
                    }
 

                    Button(action: viewModel.addItem) {
                        AddItemView(viewModel: viewModel)
                    }
                    .buttonStyle(.scaleReactive(factor: 1.05))
                }
                .padding(.fsPaddingMedium)
                .padding(.bottom, .fsPaddingLarge)
            }
        }
        .navigationTitle("Panels")
        .overlay(
            DebugView()
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
            VStack(spacing: .fsPaddingMedium) {
                Image(uiImage: panel.previewImage ?? UIImage())
                    .resizable()
                    .aspectRatio(.init(width: 1.0, height: 1.0), contentMode: .fit)
                    .background(Color.fsWhite)
                    .cornerRadius(10)
                    .clipped()

                // TODO: - Number in Comic (in final product)
                Text("\(panel.creationDate?.toString() ?? Date.nilString)")
                    .font(.fsSubtitle)
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
                    .stroke(Color.fsGray, style: StrokeStyle(lineWidth: 4, dash: [15.0]))
                    .aspectRatio(1, contentMode: .fit)
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


