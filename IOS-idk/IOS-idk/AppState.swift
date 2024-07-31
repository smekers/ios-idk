//
//  AppState.swift
//  IOS-idk
//
//  Created by Rachel Castor on 7/31/24.
//

import Foundation

@MainActor class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var notificationBoxArray: [NotificationItem] = []
    func addNotification(_ notification: NotificationItem) {
        notificationBoxArray.append(notification)
    }
    
    func removeNotification(_ notification: NotificationItem) {
        self.notificationBoxArray.removeAll { $0.id == notification.id }
    }
}
