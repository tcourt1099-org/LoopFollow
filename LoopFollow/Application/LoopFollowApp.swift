// LoopFollow
// LoopFollowApp.swift

import SwiftUI

@main
struct LoopFollowApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    init() {
        // Force-load MainViewController.shared so its viewDidLoad runs at launch.
        // All app-lifecycle work (Combine sinks, observers, scheduleAllTasks,
        // migrations) lives there and must run regardless of whether the Home
        // tab is rendered (it isn't, if the user moved Home to the Menu).
        MainViewController.shared.loadViewIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onOpenURL { url in
                    guard url.scheme == AppGroupID.urlScheme, url.host == "la-tap" else { return }
                    #if !targetEnvironment(macCatalyst)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .liveActivityDidForeground, object: nil)
                        }
                    #endif
                }
        }
    }
}
