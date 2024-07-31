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

extension View {
    @MainActor
    func notificationBox() -> some View {
        self.modifier(NotificationBoxModifier())
    }
}

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
                .foregroundColor(.gray)
                .padding(0)
            Text(notificationText)
                .font(Font.custom("Work Sans", size: 16))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
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
                .stroke(.green, lineWidth: 2)
        )
        .padding(.horizontal, 28)
        }
    }

    var notificationImage: Image {
        switch notificationType {
        case .newSiv:
            return Image(systemName: "bolt.fill")
        case .newLinkCopy:
            return Image(systemName: "sparkles")
        default:
            return Image(systemName: "paperplane")
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

                }.animation(.easeInOut, value: AppState.shared.notificationBoxArray)
            )
    }

    @MainActor
    @ViewBuilder func mainNotificationBoxView() -> some View {
        if AppState.shared.notificationBoxArray.count > 0 {
            VStack {
                ForEach(AppState.shared.notificationBoxArray){ notification in
                    NotificationBoxView(notificationText: notification.message, notificationType: notification.type) {}
                        .padding(.bottom,16)
                        .task {
                            do {
                                try await Task.sleep(for: .seconds(5))
                                AppState.shared.removeNotification(notification)
                            } catch {
                                print("Task.sleep error \(error.localizedDescription)")
                                AppState.shared.removeNotification(notification)
                            }
                        }
                }
                Spacer()
            }
            .transition(.move(edge: .top))
        }
    }
}

#if !INJECTING
#Preview {
    NotificationBoxView(notificationText: "Sent to Jeremy, Serena + 5", notificationType: .newShare, onCancelTapped: {})
}
#endif
