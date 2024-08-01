//
//  NotificationBox.swift
//  IOS-idk
//
//  Created by Rachel Castor on 8/1/24.
//

import SwiftUI

struct NotificationBoxView: View {
    var notificationText: String
    var notificationType: NotificationType
    var onCancelTapped: () -> Void
    var body: some View {
        Button(action: {
            onCancelTapped()
        }) { HStack {
            notificationImage
                .imageScale(.medium)
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color(.black))
                .padding(0)
            Text(notificationText)
                .font(Font.custom("Work Sans", size: 16))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(.black))
                .padding(.vertical)
                .padding(.horizontal, 0)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.green, lineWidth: 2)
        )
        .padding(.horizontal, 28)
        }
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif

    var notificationImage: Image {
        switch notificationType {
        case .newSiv:
            return Image(systemName: "bolt")
        case .newLinkCopy:
            return Image(systemName: "sparkle")
        default:
            return Image(systemName: "airplane")
        }
    }
}

struct NotificationBoxModifier: ViewModifier {
    @StateObject var appState = AppState.shared
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainNotificationBoxView()

                }.animation(.easeInOut, value: appState.notificationBoxArray)
            )
        .enableInjection()
    }

    #if DEBUG
    @ObserveInjection var forceRedraw
    #endif

    @ViewBuilder func mainNotificationBoxView() -> some View {
        if appState.notificationBoxArray.count > 0 {
            VStack {
                ForEach(appState.notificationBoxArray){ notification in
                    NotificationBoxView(notificationText: notification.message, notificationType: notification.type) {}
                        .padding(.bottom,16)
                        .task {
                            do {
                                try await Task.sleep(for: .seconds(5)) //diff
                                appState.removeNotification(notification)
                            } catch {
                                appState.removeNotification(notification)
                            }
                        }
                }
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }
}
extension View {
    @MainActor
    func notificationBox() -> some View {
        self.modifier(NotificationBoxModifier())
    }
}
