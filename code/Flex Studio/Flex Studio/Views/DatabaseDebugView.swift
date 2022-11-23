//
//  DatabaseDebugView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 20.11.22.
//

import SwiftUI

struct DatabaseDebugView: View {
    @State private var debugShowInputIdentifierAlert: Bool = false
    @State private var debugInputIdentifier: String = ""
    @State private var debugBackupIdentifiers: [String] = PersistenceLayer.storedBackupIdentifiers
    
    var body: some View {
        EmptyView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Button("Backup State", action: { debugShowInputIdentifierAlert = true })
                        }
                        Section {
                            ForEach(debugBackupIdentifiers, id: \.self) { identifier in
                                Button("Restore \"\(identifier)\"", action: { applySecondaryPersistentStore(from: identifier) })
                            }
                        }
                    } label: {
                        Label("Debug", systemImage: "wand.and.stars")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.primary, .pink)
                            
                    }
                }
            }
            .alert("Backup State", isPresented: $debugShowInputIdentifierAlert, actions: {
                TextField("Identifier", text: $debugInputIdentifier)
                Button("Store", action: { storeToSecondaryPersistentStore() })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Store a copy of the underlying database to this app's documents folder.")
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
