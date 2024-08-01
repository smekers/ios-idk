//
//  AppState.swift
//  IOS-idk
//
//  Created by Rachel Castor on 7/31/24.
//

import Foundation

@MainActor
class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var isiOSAppOnMac = ProcessInfo.processInfo.isiOSAppOnMac

    @Published var notificationBoxArray: [NotificationItem] = []

    func addNotification(_ notification: NotificationItem) {
        notificationBoxArray.append(notification)
    }
    
    func removeNotification(_ notification: NotificationItem) {
        self.notificationBoxArray.removeAll { $0.id == notification.id }

    }



    @Published var pendingSivElementUUID: UUID?


    @Published var chatUnreadCount: String? = nil
    @Published var inboundUnreadCount: String? = nil
    @Published var tabBarVisible: Bool = true
    @Published var sdUpdated: Bool = false
    @Published var unprocessedConcierge: Int = 0

    @Published var debugMode: Bool = true
    private init() {}
}
