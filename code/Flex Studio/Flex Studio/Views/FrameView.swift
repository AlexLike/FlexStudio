//
//  FrameView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 16.11.22.
//

import SwiftUI

struct FrameView: View {
    static let logger = Logger.forType(FrameView.self)

    @Binding var aspectProgression: CGFloat
    /// A flag that enables or hides the resize gizmos.
    let isResizable: Bool
    /// The size of the currently framed area.
    var size: CGSize { Geometry.panelSize(for: aspectProgression) }

    /// The color of the frame
    var frameColor: Color {
        isResizable ? (isDragging ? .fsTint : .fsGray) : .fsWhite
    }

    var body: some View {
        GeometryReader { geo in

            // The frame's enclosing rectagle in view space (excluding draggers).
            let frame = Geometry.rect(for: size, in: geo.size)

            // The shape defining the thin boundary.
            let boundaryTemplate = CGPath(
                roundedRect: frame.insetBy(dx: 1.5, dy: 1.5),
                cornerWidth: 8,
                cornerHeight: 8,
                transform: nil
            )
            let boundary = Path(boundaryTemplate)

            // The shape defining all but the visible contentful area.
            let outerTemplate = CGPath(
                rect: .init(origin: .zero, size: geo.size),
                transform: nil
            ).subtracting(boundaryTemplate)
            let outer = Path(outerTemplate)

            // The shapes defining the draggable gizomos.
            let leftDragger = Self.draggerTemplate
                .applying(.init(translationX: frame.minX, y: frame.midY)
                    .rotated(by: -.pi / 2))
            let rightDragger = Self.draggerTemplate
                .applying(.init(translationX: frame.maxX, y: frame.midY)
                    .rotated(by: .pi / 2))
            let topDragger = Self.draggerTemplate
                .applying(.init(translationX: frame.midX, y: frame.minY))
            let bottomDragger = Self.draggerTemplate
                .applying(.init(translationX: frame.midX, y: frame.maxY)
                    .rotated(by: .pi))

            Canvas(rendersAsynchronously: true) { context, _ in
                context.fill(outer, with: .color(.fsBackground))
                context.stroke(boundary, with: .color(frameColor), style: .init(lineWidth: 3))
                if isResizable {
                    if aspectProgression <= 0.5 {
                        context.fill(leftDragger, with: .color(frameColor))
                        context.fill(rightDragger, with: .color(frameColor))
                    }
                    if aspectProgression >= 0.5 {
                        context.fill(topDragger, with: .color(frameColor))
                        context.fill(bottomDragger, with: .color(frameColor))
                    }
                }
            }
            .contentShape(outer)
            .gesture(resizeGesture(for: geo.size))
            .allowsHitTesting(isResizable)
        }
        .ignoresSafeArea(.all)
    }

    @State private var isDragging: Bool = false
    @State private var convert: ((CGSize) -> CGFloat)? = nil
    private func resizeGesture(for viewSize: CGSize) -> some Gesture {
        
        return DragGesture()
            .onChanged { g in
                if convert == nil {
                    isDragging = true

                    let initialFrame = Geometry.rect(for: size, in: viewSize)
                    let initialAspectProgression = aspectProgression

                    let widthRangeLeftRight = (initialFrame.midY - Self.draggerSize
                        .width / 2)...(initialFrame.midY + Self
                        .draggerSize.width / 2)
                    let widthRangeTopBottom = (initialFrame.midX - Self.draggerSize
                        .width / 2)...(initialFrame.midX + Self
                        .draggerSize.width / 2)
                    let aspectProgressionRangeWide: ClosedRange<CGFloat> = 0...0.5
                    let aspectProgressionRangeTall: ClosedRange<CGFloat> = 0.5...1

                    switch (initialAspectProgression, g.startLocation.x, g.startLocation.y) {
                    // Left Dragger
                    case (
                        aspectProgressionRangeWide,
                        (initialFrame.minX - Self.draggerSize.height)...initialFrame.minX,
                        widthRangeLeftRight
                    ): convert = { p in
                            (initialAspectProgression + p.width
                                / ((Geometry.maxFrameScale - 1) * Geometry.minFrameLength))
                                .clamped(to: aspectProgressionRangeWide)
                        }
                        Self.logger.notice("Began dragging the left edge.")
                    // Right Dragger
                    case (
                        aspectProgressionRangeWide,
                        (initialFrame.maxX)...(initialFrame.maxX + Self.draggerSize.height),
                        widthRangeLeftRight
                    ): convert = { p in
                            (initialAspectProgression - p.width
                                / ((Geometry.maxFrameScale - 1) * Geometry.minFrameLength))
                                .clamped(to: aspectProgressionRangeWide)
                        }
                        Self.logger.notice("Began dragging the right edge.")
                    // Top Dragger
                    case (
                        aspectProgressionRangeTall,
                        widthRangeTopBottom,
                        (initialFrame.minY - Self.draggerSize.height)...(initialFrame.minY)
                    ): convert = { p in
                            (initialAspectProgression - p.height
                                / ((Geometry.maxFrameScale - 1) * Geometry.minFrameLength))
                                .clamped(to: aspectProgressionRangeTall)
                        }
                        Self.logger.notice("Began dragging the top edge.")
                    // Bottom Dragger
                    case (
                        aspectProgressionRangeTall,
                        widthRangeTopBottom,
                        (initialFrame.maxY)...(initialFrame.maxY + Self.draggerSize.height)
                    ): convert = { p in
                            (initialAspectProgression + p.height
                                / ((Geometry.maxFrameScale - 1) * Geometry.minFrameLength))
                                .clamped(to: aspectProgressionRangeTall)
                        }
                        Self.logger.notice("Began dragging the bottom edge.")
                    default:
                        convert = { _ in initialAspectProgression }
                        isDragging = false
                    }
                }

                if let convert {
                    aspectProgression = convert(g.translation)
                }
            }
            .onEnded { _ in
                Self.logger.notice("Stopped dragging.")
                convert = nil
                isDragging = false
            }
    }

    static let draggerSize = CGSize(width: 400, height: 200)
    static let draggerTemplate = Path { p in
        p.move(to: CGPoint(x: 17.5, y: -16))
        p.addLine(to: CGPoint(x: -17.5, y: -16))
        p.addCurve(
            to: CGPoint(x: -18.42, y: -15.68),
            control1: CGPoint(x: -17.85, y: -16),
            control2: CGPoint(x: -18.17, y: -15.88)
        )
        p.addCurve(
            to: CGPoint(x: -19, y: -14.5),
            control1: CGPoint(x: -18.77, y: -15.41),
            control2: CGPoint(x: -19, y: -14.98)
        )
        p.addCurve(
            to: CGPoint(x: -17.5, y: -13),
            control1: CGPoint(x: -19, y: -13.67),
            control2: CGPoint(x: -18.33, y: -13)
        )
        p.addLine(to: CGPoint(x: 17.5, y: -13))
        p.addCurve(
            to: CGPoint(x: 19, y: -14.5),
            control1: CGPoint(x: 18.33, y: -13),
            control2: CGPoint(x: 19, y: -13.67)
        )
        p.addCurve(
            to: CGPoint(x: 17.5, y: -16),
            control1: CGPoint(x: 19, y: -15.33),
            control2: CGPoint(x: 18.33, y: -16)
        )
        p.closeSubpath()
        p.move(to: CGPoint(x: 17.5, y: -7))
        p.addLine(to: CGPoint(x: -17.5, y: -7))
        p.addCurve(
            to: CGPoint(x: -19, y: -5.5),
            control1: CGPoint(x: -18.33, y: -7),
            control2: CGPoint(x: -19, y: -6.33)
        )
        p.addCurve(
            to: CGPoint(x: -17.5, y: -4),
            control1: CGPoint(x: -19, y: -4.67),
            control2: CGPoint(x: -18.33, y: -4)
        )
        p.addLine(to: CGPoint(x: 17.5, y: -4))
        p.addCurve(
            to: CGPoint(x: 19, y: -5.5),
            control1: CGPoint(x: 18.33, y: -4),
            control2: CGPoint(x: 19, y: -4.67)
        )
        p.addCurve(
            to: CGPoint(x: 17.5, y: -7),
            control1: CGPoint(x: 19, y: -6.33),
            control2: CGPoint(x: 18.33, y: -7)
        )
        p.closeSubpath()
        p.move(to: CGPoint(x: 32, y: -15))
        p.addLine(to: CGPoint(x: 32, y: -8))
        p.addCurve(
            to: CGPoint(x: 40, y: 0),
            control1: CGPoint(x: 32, y: -3.58),
            control2: CGPoint(x: 35.58, y: 0)
        )
        p.addLine(to: CGPoint(x: -40, y: 0))
        p.addCurve(
            to: CGPoint(x: -32, y: -8),
            control1: CGPoint(x: -35.58, y: 0),
            control2: CGPoint(x: -32, y: -3.58)
        )
        p.addCurve(
            to: CGPoint(x: -32, y: -11.6),
            control1: CGPoint(x: -32, y: -8),
            control2: CGPoint(x: -32, y: -9.82)
        )
        p.addCurve(
            to: CGPoint(x: -32, y: -15),
            control1: CGPoint(x: -32, y: -13.32),
            control2: CGPoint(x: -32, y: -15)
        )
        p.addCurve(
            to: CGPoint(x: -31.86, y: -16.48),
            control1: CGPoint(x: -32, y: -15.51),
            control2: CGPoint(x: -31.95, y: -16)
        )
        p.addCurve(
            to: CGPoint(x: -24, y: -23),
            control1: CGPoint(x: -31.17, y: -20.19),
            control2: CGPoint(x: -27.91, y: -23)
        )
        p.addLine(to: CGPoint(x: 24, y: -23))
        p.addCurve(
            to: CGPoint(x: 32, y: -15),
            control1: CGPoint(x: 28.42, y: -23),
            control2: CGPoint(x: 32, y: -19.42)
        )
        p.closeSubpath()
    }
}

struct FrameView_Previews: PreviewProvider {
    struct Container: View {
        @State var aspectProgression: CGFloat = 0.5

        var body: some View {
            VStack {
                FrameView(aspectProgression: $aspectProgression, isResizable: true)
                VStack(alignment: .leading) {
                    Text(
                        "Aspect Progression \(aspectProgression, format: .percent.precision(.integerAndFractionLength(integerLimits: 0...3, fractionLimits: 0...0)))"
                    )
                    .font(.body.monospacedDigit())
                    Slider(value: $aspectProgression, in: 0...1)
                }
                .frame(maxWidth: 300)
                .padding()
            }
            .background(Color.yellow)
            .preferredColorScheme(.light)
        }
    }

    static var previews: some View {
        Container()
    }
}
