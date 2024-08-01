//
//  Home.swift
//  IOS-idk
//
//  Created by Rachel Castor on 7/31/24.
//

import SwiftUI

struct Home: View {
    @StateObject var appState = AppState.shared
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: NotificationIssues(), label: {
                    Text("Notification Issues")
                })
                ForEach(AppState.shared.notificationBoxArray) { notification in
                    Text(notification.message)
                }
                Spacer()
            }
            .navigationTitle("Home")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .notificationBox()
        }
    }
}

#Preview {
    Home()
}

#if !INJECTING
#Preview {
    NotificationBoxView(notificationText: "Sent to Jeremy, Serena + 5", notificationType: .newShare, onCancelTapped: {})
}
#endif
