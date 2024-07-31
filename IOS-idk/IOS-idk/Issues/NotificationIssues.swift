//
//  NotificationIssues.swift
//  IOS-idk
//
//  Created by Rachel Castor on 7/31/24.
//

import SwiftUI

struct NotificationIssues: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("NotificationIssue")
        Text("Add Notification")
        Button("Add Notification") {
            UIPasteboard.general.string = "https://youtu.be/uE-1RPDqJAY?si=xhkAuVYvgxTBjmpz"
            AppState.shared.addNotification(NotificationItem(message: "Copied Link", type: .newLinkCopy))
            dismiss()
        }
    }
}

#Preview {
    NotificationIssues()
}
