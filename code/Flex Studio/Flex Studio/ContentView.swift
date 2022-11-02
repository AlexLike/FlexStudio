//
//  ContentView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 28.10.22.
//

import PencilKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            PanelView(
                layers: PanelView_Previews.demoLayers,
                selectedLayer: PanelView_Previews.demoLayers[1],
                selectedTool: .debugDraw,
                targetSize: .zero
            )
            .navigationTitle("Panel Editor")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
