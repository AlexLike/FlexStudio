//
//  PinGizmo.swift
//  Flex Studio
//
//  Created by Karl Robert Kristenprun on 16.11.2022.
//

import SwiftUI

struct PinGizmo<A: PinAssistant>: ResponsivityGizmo {
    let logger = Logger.forType(PinGizmo.self)
    @ObservedObject var assistant: A

    let rowWiseLocations = stride(from: 0, to: 9, by: 3)
        .map { PinLocation.allCases[$0..<($0 + 3)] }

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(rowWiseLocations, id: \.startIndex) { rowLocations in
                GridRow {
                    ForEach(rowLocations) { location in
                        let isSelected = assistant.selectedPinLocation == location
                        Button {
                            if assistant.selectedPinLocation != location {
                                assistant.selectedPinLocation = location
                                logger.notice("Pinned layer to \(location).")
                            } else {
                                assistant.selectedPinLocation = nil
                                logger.notice("Unpinned layer.")
                            }
                            Logger.forStudy.critical("Toggled pin location.")
                        } label: {
                            Image(systemName: isSelected ? "pin.circle" : "circle")
                                .font(.system(size: 26))
                        }
                        .frame(width: 48, height: 48)
                        .buttonStyle(.scaleReactive(factor: 1.5))
                    }
                }
            }
        }
        .padding([.top, .leading])
    }

    private var bottomText: String {
        switch assistant.selectedPinLocation {
        case .some(.loc(_, .left)): return "left-aligned"
        case .some(.loc(_, .center)): return "flexible"
        case .some(.loc(_, .right)): return "right-aligned"
        case .none: return "static"
        }
    }

    private var rightText: String {
        switch assistant.selectedPinLocation {
        case .some(.loc(.top, _)): return "top-aligned"
        case .some(.loc(.center, _)): return "flexible"
        case .some(.loc(.bottom, _)): return "bottom-aligned"
        case .none: return "static"
        }
    }

    var bottomSupport: some View {
        Text(bottomText)
    }

    var rightSupport: some View {
        Text(rightText)
    }
}

struct Previews_PinGizmo_Previews: PreviewProvider {
    
    class MockAssistant: PinAssistant {
        let isEditingResponsivity = true
        @Published var selectedPinLocation: PinLocation? = .loc(.center, .center)
    }
    
    struct Container: View {
        @StateObject var assistant = MockAssistant()

        var body: some View {
            let gizmo = PinGizmo(assistant: MockAssistant())

            VStack(spacing: 24) {
                gizmo
                gizmo.bottomSupport
                gizmo.rightSupport
            }
        }
    }

    static var previews: some View {
        Container()
    }
}
