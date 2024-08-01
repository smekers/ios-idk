//
//  IOS_idkApp.swift
//  IOS-idk
//
//  Created by Rachel Castor on 7/31/24.
//

import SwiftUI
import SwiftData

@main
struct IOS_idkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NotificationMySivs()
        }
//        .modelContainer(sharedModelContainer)
    }
}
