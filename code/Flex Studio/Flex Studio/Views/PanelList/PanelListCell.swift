//
//  PanelListCell.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct PanelListCell: View {
    @ObservedObject var panel: Panel
    @State var isEditingName: Bool = false
    @State var editableTitle: String = ""

    var body: some View {
        VStack(spacing: 24) {
            NavigationLink(destination: EditorView(panel: panel)) {
                Color.white
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        if let thumbnail = panel.thumbnail {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .scaledToFit()
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 32)
                                        .inset(by: 3)
                                )
                        } else {
                            EmptyView()
                        }
                    }
                    .cornerRadius(32)
            }
            .buttonStyle(.scaleReactive(factor: 1.05))

            Text(panel.title ?? panel.creationDate?.formatted(date: .abbreviated, time: .shortened) ?? "unnamed")
                .font(.subheadline)
                .foregroundColor(.gray)
                .onTapGesture { isEditingName = true }
                .alert("Change Title", isPresented: $isEditingName, actions: {
                    TextField("Your Creative Title", text: $editableTitle)
                        .onAppear { editableTitle = panel.title ?? "" }
                    Button("OK") { panel.title = editableTitle.isEmpty ? nil : editableTitle }
                    Button("Cancel", role: .cancel) {}
                }, message: {
                    Text("Let all your creativity out while naming this panel.")
                })

            Spacer()
        }
    }
}
