//
//  Notification.swift
//  IOS-idk
//
//  Created by Rachel Castor on 7/31/24.
//

import Foundation

enum NotificationType: String {
    case newShare
    case newSiv
    case newSivWithShare
    case newRequest
    case newLinkCopy
}

struct NotificationItem: Identifiable, Equatable {
    let id = UUID()
    var message: String
    var type: NotificationType
}
