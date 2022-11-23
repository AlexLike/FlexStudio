//
//  StudyControlView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 23.11.22.
//

import SwiftUI

struct StudyControlView: View {
    @Binding var responsivityInterfaceVariant: ResponsivityInterfaceVariant

    enum StudyState {
        case setup
        case waitingForFirstInput
        case inProgress
    }

    @State var studyState: StudyState = .setup
    @State var t0: Date = .distantPast

    var body: some View {
        EmptyView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    switch studyState {
                    case .setup:
                        Menu {
                            Button {
                                studyState = .waitingForFirstInput
                                Logger.forStudy
                                    .critical(
                                        "Testing the \(String(describing: responsivityInterfaceVariant), privacy: .public) responsivity interface variant."
                                    )
                            } label: {
                                Label("Run Test", systemImage: "figure.run")
                            }
                            Picker(
                                "Responsivity Interface Variant",
                                selection: $responsivityInterfaceVariant
                            ) {
                                Text("Indirect").tag(ResponsivityInterfaceVariant.indirect)
                                Text("Direct").tag(ResponsivityInterfaceVariant.direct)
                            }
                        } label: {
                            Label("Study Control", systemImage: "wand.and.stars")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.primary, .pink)
                                .fontWeight(.bold)
                        }
                    case .waitingForFirstInput:
                        Button {
                            studyState = .inProgress
                            t0 = .now
                            Logger.forStudy.critical("The participant begins the task.")
                        } label: {
                            Group {
                                Text("Begin Task")
                                Image(systemName: "recordingtape.circle")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.primary, .pink)
                            }
                            .fontWeight(.bold)
                        }
                    case .inProgress:
                        Button {
                            studyState = .setup
                            let duration = Calendar.current.dateComponents(
                                [.minute, .second],
                                from: t0,
                                to: .now
                            )
                            Logger.forStudy
                                .critical(
                                    "The participant finishes the task. Duration: \(duration.minute ?? 0, privacy: .public):\(duration.second ?? 0, format: .decimal(minDigits: 2), privacy: .public) min"
                                )
                        } label: {
                            Group {
                                Text("Finish Task")
                                    .foregroundColor(.pink)
                                Image(
                                    systemName: "recordingtape.circle.fill"
                                )
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.pink)
                            }
                            .fontWeight(.bold)
                        }
                    }
                }
            }
            .onAppear {
                guard let window = (UIApplication
                    .shared.connectedScenes.first
                    as? UIWindowScene)?.keyWindow else { return }
                window.swizzle()
            }
    }
}
