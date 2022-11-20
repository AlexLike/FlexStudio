//
//  ResponsivityControlView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 17.11.22.
//

import SwiftUI

///
/// The protocol implemented by all responsivity control variants.
///
/// Both interface variations provide one central control through their `body` property and
/// two pieces of supplemental views through their `bottomSupport` and
/// `rightSupport` properties.
///
/// At compile time, the two `ResponsivityControlView`s specialize.
///
protocol ResponsivityGizmo: View {
    associatedtype Bottom: View
    associatedtype Right: View

    @ViewBuilder @MainActor var bottomSupport: Bottom { get }
    @ViewBuilder @MainActor var rightSupport: Right { get }
}

///
/// A view containing all menu controls for editing responsivity.
///
/// - `ResponsivityControlView.indirect(:,:)` yields a pin menu.
/// - `ResponsivityControlView.direct(:)` yields a keyframe menu.
///
struct ResponsivityControlView<G: ResponsivityGizmo, A>: View {
    // Convenience initializers are available below as static members.
    let gizmo: G
    @Binding var isExpanded: Bool

    let cornerRadius: CGFloat = 32

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                if isExpanded {
                    gizmo
                    gizmo.rightSupport
                        .font(.subheadline)
                        .fixedSize()
                        .rotationEffect(.radians(-.pi / 2))
                        .frame(width: 2 * cornerRadius)
                }
            }
            GridRow {
                if isExpanded {
                    gizmo.bottomSupport
                        .font(.subheadline)
                }
                Button {
                    withAnimation(
                        .spring(
                            response: 0.4,
                            dampingFraction: isExpanded ? 1 : 0.8,
                            blendDuration: 0
                        )
                    ) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "pencil.and.outline" : "lasso.and.sparkles")
                        .font(.title2)
                        .frame(
                            minWidth: 2 * cornerRadius,
                            minHeight: 2 * cornerRadius
                        )
                        .background(isExpanded ? Color.fsGray : Color.fsWhite)
                }
                .buttonStyle(.static)
                .clipShape(Circle())
            }
        }
        .background(Color.fsWhite)
        .cornerRadius(cornerRadius)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

extension ResponsivityControlView where G == PinGizmo<A> {
    static func indirect(
        isExpanded: Binding<Bool>,
        assistant: A
    ) -> Self {
        .init(
            gizmo: .init(assistant: assistant),
            isExpanded: isExpanded
        )
    }
}

extension ResponsivityControlView where G == KeyframeGizmo<A> {
    static func direct(
        isExpanded: Binding<Bool>,
        assistant: A
    ) -> Self {
        .init(
            gizmo: .init(assistant: assistant),
            isExpanded: isExpanded
        )
    }
}

struct ResponsivityControl_Previews: PreviewProvider {
    class MockAssistant: PinAssistant, KeyframeAssistant {
        @Published var aspectProgression: CGFloat = 0.75

        @Published var selectedPinLocation: PinLocation? = .loc(.center, .center)
        @Published var sortedKeyframeProgressions: [CGFloat] = [0.2, 0.45, 0.77]

        func toggleKeyframe() {}
    }

    struct Container: View {
        let variant: ResponsivityInterfaceVariant
        @State var isExpanded: Bool = true
        @StateObject var assistant = MockAssistant()

        var body: some View {
            switch variant {
            case .indirect:
                ResponsivityControlView.indirect(
                    isExpanded: $isExpanded,
                    assistant: assistant
                )
            case .direct:
                ResponsivityControlView.direct(
                    isExpanded: $isExpanded,
                    assistant: assistant
                )
            }
        }
    }

    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Container(variant: .direct)
            }
        }
        .frame(maxWidth: 500, maxHeight: 500)
        .padding()
    }
}
