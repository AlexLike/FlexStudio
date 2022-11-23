//
//  LayerSelectionCell.swift
//  Flex Studio
//
//  Created by Tim Kluser on 08.11.22.
//

import SwiftUI

struct LayerSelectionCell: View {
    @ObservedObject var layer: Layer
    let isSelected: Bool
    
    var body: some View {
        HStack {
            // Thumbnail
            Color.white
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let thumbnail = layer.thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "ellipsis")
                            .foregroundColor(isSelected ? .accent : .secondary)
                    }
                }
                .clipShape(ContainerRelativeShape())
                .padding(4)
            
            // Visibility Control
                HStack {
                    Spacer()
                    Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                        .font(.system(size: 14))
                        .foregroundColor(isSelected ? .accent : .secondary)
                    Spacer()
                }
                .gesture(TapGesture().onEnded { _ in
                    layer.isVisible.toggle()
                    Logger.forStudy.critical("Toggled layer visibility.")
                })
        }
        .background(isSelected ? Color.accent.opacity(0.25) : nil)
        .clipShape(ContainerRelativeShape())
        .frame(height: 80)
        .padding(.horizontal, 8)
    }
}
