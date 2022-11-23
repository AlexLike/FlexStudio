//
//  LayerSelectionView.swift
//  Flex Studio
//
//  Created by Tim Kluser on 08.11.22.
//

import SwiftUI

struct LayerSelectionView<A: LayerSelectionAssistant>: View {
    @ObservedObject var assistant: A
    let allowsAddingLayers: Bool

    var body: some View {
        VStack {
            Text("Layers")
                .font(.title2.weight(.semibold))
                .foregroundColor(.primary)
                .padding(.top, 50)
                .padding(.bottom, 20)

            List {
                ForEach(assistant.sortedLayers) { layer in
                    LayerSelectionCell(layer: layer, isSelected: assistant.selectedLayer == layer)
                        .gesture(TapGesture().onEnded { _ in
                            assistant.selectedLayer = layer
                            Logger.forStudy.critical("Selected layer.")
                        })
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                assistant.deleteLayer(layer)
                                Logger.forStudy.critical("Deleted layer.")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .containerShape(RoundedRectangle(cornerRadius: 16))
                }
                .onMove(perform: { assistant.moveLayers(from: $0, to: $1) })
                .listRowBackground(EmptyView())
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            Button {
                assistant.createLayer()
                Logger.forStudy.critical("Created layer.")
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.accent)
                    .font(.largeTitle)
            }
            .buttonStyle(.scaleReactive(factor: 1.2))
            .padding(.top, 20)
            .padding(.bottom, 50)
            .opacity(allowsAddingLayers ? 1 : 0)
        }
        .frame(width: 150, height: 500)
        .background(Color.toolPickerWhite)
        .cornerRadius(75)
        .toolShadow()
    }
}
