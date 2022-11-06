//
//  Flex_StudioApp.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import SwiftUI

@main
struct Flex_StudioApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, PersistenceLayer.shared.viewContext)
        }
        .onChange(of: scenePhase) {
            switch $0 {
            case .background, .inactive: PersistenceLayer.shared.save()
            case .active: ()
            @unknown default: ()
            }
        }
    }
}
