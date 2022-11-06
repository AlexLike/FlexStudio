//
//  Flex_StudioApp.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Global NavigationBar styling
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.font: UIFont.fs_title!, .foregroundColor: UIColor(Color.fs_black)]
        appearance.largeTitleTextAttributes = [.font: UIFont.fs_header!, .foregroundColor: UIColor(Color.fs_black)]
        appearance.backgroundColor = UIColor(Color.fs_background)
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
      
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return true
    }
}

@main
struct Flex_StudioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            MainNavigationView().environment(\.managedObjectContext, PersistenceLayer.shared.viewContext)
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
