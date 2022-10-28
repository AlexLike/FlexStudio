//
//  Flex_StudioApp.swift
//  Flex Studio
//
//  Created by Alexander Zank on 28.10.22.
//

import SwiftUI

@main
struct Flex_StudioApp: App {
    @StateObject var database = Database()
//  @StateObject var myService: MyService
    
    init() {
//        _myService = StateObject(wrappedValue: MyService(database: database))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//              .environmentObject(myService)
        }
    }
}
