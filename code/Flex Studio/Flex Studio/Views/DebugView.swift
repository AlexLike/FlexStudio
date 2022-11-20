//
//  DebugView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 20.11.22.
//

import SwiftUI

struct DebugView: View {
    @AppStorage(PersistenceLayer.debugBackupsKey) private var debugBackupIdentifiers: [String] = []
    @State private var debugShowInputIdentifierAlert: Bool = false
    @State private var debugInputIdentifier: String = ""
    
    var body: some View {
        EmptyView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Debug") {
                        Section {
                            Button("Store", action: { debugShowInputIdentifierAlert = true })
                        }
                        Section {
                            ForEach(debugBackupIdentifiers, id: \.self) { identifier in
                                Button("Apply \"\(identifier)\"", action: { applySecondaryPersistentStore(from: identifier) })
                            }
                        }
                    }
                }
            }
            .alert("Identifier", isPresented: $debugShowInputIdentifierAlert, actions: {
                TextField("Identifier", text: $debugInputIdentifier)
                Button("Store", action: { storeToSecondaryPersistentStore() })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Enter an identifier")
            })
    }
    
    @MainActor func storeToSecondaryPersistentStore() {
        do {
            try PersistenceLayer.shared.container.copyPersistentStores(identifier: debugInputIdentifier)
            debugBackupIdentifiers.append(debugInputIdentifier)
        } catch {
            print(error)
        }
    }
    
    @MainActor func applySecondaryPersistentStore(from identifier: String) {
        do {
            try PersistenceLayer.shared.container.restorePersistentStore(identifier: identifier)
            exit(0)
        } catch {
            print(error)
        }
    }
}
