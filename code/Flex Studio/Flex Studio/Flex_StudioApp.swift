//
//  Flex_StudioApp.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import SwiftUI

@main
struct Flex_StudioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            MainNavigationView()
                .environment(\.managedObjectContext, PersistenceLayer.shared.viewContext)
                .preferredColorScheme(.light)
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Global NavigationBar styling
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.fs_title!,
            .foregroundColor: UIColor(Color.fsBlack),
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.fs_header!,
            .foregroundColor: UIColor(Color.fsBlack),
        ]
        appearance.backgroundColor = UIColor(Color.fsBackground)
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        return true
    }
}
