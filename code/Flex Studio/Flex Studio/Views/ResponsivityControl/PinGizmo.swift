//
//  PinGizmo.swift
//  Flex Studio
//
//  Created by Karl Robert Kristenprun on 16.11.2022.
//

import SwiftUI

struct PinGizmo: ResponsivityGizmo {
    static let logger = Logger.forType(PinGizmo.self)
    
    @Binding var selectedLocation: PinLocation?

    static let rowWiseLocations = stride(from: 0, to: 9, by: 3)
        .map { PinLocation.allCases[$0..<($0 + 3)] }

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(Self.rowWiseLocations, id: \.startIndex) { rowLocations in
                GridRow {
                    ForEach(rowLocations) { location in
                        let isSelected = selectedLocation == location
                        Button {
                            selectedLocation = location
                            Self.logger.notice("Pinned layer to \(location).")
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
    }

    private func asideText(_ content: String) -> some View {
        Text(content)
            .font(.subheadline)
    }

    private var bottomText: String {
        switch selectedLocation {
        case .some(.loc(.top, _)): return "top-aligned"
        case .some(.loc(.center, _)): return "flexible"
        case .some(.loc(.bottom, _)): return "bottom-aligned"
        case .none: return "static"
        }
    }

    private var rightText: String {
        switch selectedLocation {
        case .some(.loc(_, .left)): return "left-aligned"
        case .some(.loc(_, .center)): return "flexible"
        case .some(.loc(_, .right)): return "right-aligned"
        case .none: return "static"
        }
    }

    var bottomSupport: some View {
        asideText(bottomText)
    }

    var rightSupport: some View {
        asideText(rightText)
    }
}

struct Previews_PinGizmo_Previews: PreviewProvider {
    struct Container: View {
        @State var pinnedLocation: PinLocation? = .loc(.center, .center)

        var body: some View {
            let gizmo = PinGizmo(selectedLocation: $pinnedLocation)

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
