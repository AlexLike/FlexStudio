//
//  KeyframeGizmo.swift
//  Flex Studio
//
//  Created by Alexander Zank on 18.11.22.
//

import SwiftUI

struct KeyframeGizmo<A: KeyframeAssistant>: ResponsivityGizmo {
    @ObservedObject var assistant: A

    var isOnKeyframe: Bool {
        assistant.currentKeyframe != nil
    }

    let timelineSize: CGSize = .init(width: 300, height: 24)
    let padding: CGFloat = 20
    var coordinateRange: ClosedRange<CGFloat> {
        let inset = padding + timelineSize.height / 2
        return inset...(timelineSize.width - inset)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    assistant.aspectProgression = assistant.sortedKeyframeProgressions
                        .last(where: { $0 < assistant.aspectProgression })
                        ?? 0
                } label: {
                    Image(systemName: "chevron.left.2")
                        .fontWeight(.medium)
                        .padding()
                }
                Button {
                    assistant.toggleKeyframe()
                } label: {
                    ZStack {
                        if isOnKeyframe {
                            Rhombus().fill(.yellow)
                        } else {
                            Image(systemName: "plus")
                                .fontWeight(.medium)
                        }
                        Rhombus().stroke(style: .init(lineWidth: 2))
                    }
                    .frame(width: 32, height: 32)
                    .padding()
                }
                Button {
                    assistant.aspectProgression = assistant.sortedKeyframeProgressions
                        .first(where: { $0 > assistant.aspectProgression })
                        ?? 1
                } label: {
                    Image(systemName: "chevron.right.2")
                        .fontWeight(.medium)
                        .padding()
                }
            }
            .buttonStyle(.scaleReactive(factor: 1.6))
            .padding()

            let bottomLine = Path { p in
                p.move(to: .init(x: coordinate(fromRelativeValue: 0),
                                 y: timelineSize.height))
                p.addLine(to: .init(x: coordinate(fromRelativeValue: 1),
                                    y: timelineSize.height))
            }

            let tallLedgers = ledgers(
                height: timelineSize.height,
                count: 3
            )

            let shortLedgers = ledgers(
                height: timelineSize.height / 2 - 3,
                count: 19
            )

            let keyframeMarkers: [Path] = assistant.sortedKeyframeProgressions.map { pos in
                Rhombus()
                    .path(in: .init(
                        x: coordinate(fromRelativeValue: pos) -
                            (timelineSize.height / 2 - 6),
                        y: 6,
                        width: 2 * (timelineSize.height - 6) / 3,
                        height: timelineSize.height - 6
                    ))
            }

            let indicator = indicator(
                at: coordinate(fromRelativeValue: assistant.aspectProgression)
            )

            Canvas(rendersAsynchronously: true) { context, _ in
                context.stroke(bottomLine, with: .color(.fsGray))

                for shortLedger in shortLedgers {
                    context.stroke(shortLedger, with: .color(.fsGray))
                }

                for tallLedger in tallLedgers {
                    context.stroke(tallLedger, with: .color(.primary), lineWidth: 2)
                }

                for keyframeMarker in keyframeMarkers {
                    context.fill(keyframeMarker, with: .color(.yellow))
                }

                context.fill(indicator, with: .color(.red))
            }
            .frame(width: timelineSize.width, height: timelineSize.height)
        }
    }

    var bottomSupport: some View {
        HStack {
            Image(systemName: "rectangle.arrowtriangle.2.inward")
                .frame(width: timelineSize.height)
                .padding(.leading, padding)
            Text("wide")
            Spacer()
            Text("tall")
            Image(systemName: "rectangle.portrait.arrowtriangle.2.inward")
                .frame(width: timelineSize.height)
                .padding(.trailing, padding)
        }
        .frame(width: timelineSize.width)
    }

    var rightSupport: some View {
        Text(isOnKeyframe ? "manual" : "interpolated")
    }

    func indicator(at coordinate: CGFloat) -> Path {
        Path { bezierPath in
            bezierPath.move(to: CGPoint(x: 4, y: 0))
            bezierPath.addLine(to: CGPoint(x: 1, y: 6))
            bezierPath.addLine(to: CGPoint(x: 1, y: timelineSize.height))
            bezierPath.addLine(to: CGPoint(x: -1, y: timelineSize.height))
            bezierPath.addLine(to: CGPoint(x: -1, y: 6))
            bezierPath.addLine(to: CGPoint(x: -4, y: 0))
            bezierPath.addLine(to: CGPoint(x: 4, y: 0))
        }.applying(.init(translationX: coordinate, y: 0))
    }

    func ledgers(height: CGFloat, count: Int) -> [Path] {
        let ledgerTemplate = Path { p in
            p.move(to: .init(x: 0, y: timelineSize.height - height))
            p.addLine(to: .init(x: 0, y: timelineSize.height))
        }

        return (0..<count).map { i in
            ledgerTemplate.applying(.init(
                translationX: coordinate(fromRelativeValue: CGFloat(i) / CGFloat(count - 1)),
                y: 0
            ))
        }
    }

    func coordinate(fromRelativeValue aspectProgression: CGFloat) -> CGFloat {
        coordinateRange.lowerBound
            + aspectProgression * (coordinateRange.upperBound - coordinateRange.lowerBound)
    }
}

struct KeyframeGizmo_Previews: PreviewProvider {
    class MockAssistant: KeyframeAssistant {
        var currentOffset: CGSize = .zero
        
        func modifyCurrentKeyframePosition(to target: CGSize) {
            
        }
        
        let isEditingResponsivity = true
        @Published var aspectProgression: CGFloat = 0.22
        @Published var sortedKeyframeProgressions: [CGFloat] = [0, 0.2, 0.45, 0.88, 1]
        
        var currentKeyframe: Keyframe? = nil
        func toggleKeyframe() {}
    }

    struct Container: View {
        @StateObject var assistant = MockAssistant()

        var body: some View {
            let gizmo = KeyframeGizmo(assistant: assistant)

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
