//
//  PanelResizeView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 07.11.22.
//

import SwiftUI

struct PanelResizingView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @ObservedObject var panel: Panel
    @ObservedObject var viewModel: PanelViewModel
    let proxy: GeometryProxy

    static let strokeWidth: CGFloat = 2

    var body: some View {
        ZStack {
            if case .some(.responsivity(_)) = viewModel.selectedTool {
                ZStack {
                    HStack {
                        ResizingShapeView(state: $viewModel.selectedTool, edge: .leading)
                            .gesture(viewModel.rezisingDragGesture(.leading, proxy, panel))

                        Spacer()
                        ResizingShapeView(state: $viewModel.selectedTool, edge: .trailing)
                            .gesture(viewModel.rezisingDragGesture(.trailing, proxy, panel))
                    }

                    VStack {
                        ResizingShapeView(state: $viewModel.selectedTool, edge: .top)
                            .gesture(viewModel.rezisingDragGesture(.top, proxy, panel))

                        Spacer()
                        ResizingShapeView(state: $viewModel.selectedTool, edge: .bottom)
                            .gesture(viewModel.rezisingDragGesture(.bottom, proxy, panel))
                    }
                }
                .frame(
                    width: ((viewModel.canvasWidth(proxy, panel) ?? 0) * viewModel.panelScale) +
                        PanelResizingView.strokeWidth,
                    height: ((viewModel.canvasHeight(proxy, panel) ?? 0) * viewModel.panelScale) +
                        PanelResizingView.strokeWidth,
                    alignment: .center
                )
            } else { EmptyView() }

            HStack {
                Spacer()
                VStack {
                    Spacer()
                    FSToolCircleButton(symbol: Image.fsResize) { _ in
                        viewModel.toggleResponsivity()
                    }
                    .padding(20 /* safeAreainsets.bottom */ )
                }
            }
        }
    }

    private struct ResizingShapeView: View {
        @Binding var state: EditorTool?
        let edge: Edge

        var color: Color {
            withAnimation {
                if case .responsivity(byDragging: true) = state { return .fsTint }
                else { return .fsDarkGray }
            }
        }

        var body: some View {
            ZStack {
                // Hack to increase drag area
                ResizingShape(edge: edge)
                    .stroke(Color.fsWhite.opacity(0.001), lineWidth: 30)

                ResizingShape(edge: edge)
                    .stroke(color, lineWidth: PanelResizingView.strokeWidth)
                    .background(ResizingShape(edge: edge).fill(color))
            }
        }
    }
}

private struct ResizingShape: Shape {
    let edge: Edge

    init(edge: Edge) {
        self.edge = edge
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let handleLength: CGFloat = 50.0
        let handleHeight: CGFloat = 3.0

        let minX: CGFloat = 0
        let minY: CGFloat = 0
        let maxX: CGFloat = rect.width
        let maxY: CGFloat = rect.height

        switch edge {
        case .top:
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: minY))
            path.addRect(CGRect(
                x: maxX / 2 - handleLength / 2,
                y: -handleHeight,
                width: handleLength,
                height: handleHeight
            ))

        case .bottom:
            path.move(to: CGPoint(x: minX, y: maxY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path
                .addRect(CGRect(x: maxX / 2 - handleLength / 2, y: maxY, width: handleLength,
                                height: handleHeight))

        case .leading:
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: minX, y: maxY))
            path.addRect(CGRect(
                x: -handleHeight,
                y: maxY / 2 - handleLength / 2,
                width: handleHeight,
                height: handleLength
            ))

        case .trailing:
            path.move(to: CGPoint(x: maxX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path
                .addRect(CGRect(x: maxX, y: maxY / 2 - handleLength / 2, width: handleHeight,
                                height: handleLength))
        }

        return path
    }
}
