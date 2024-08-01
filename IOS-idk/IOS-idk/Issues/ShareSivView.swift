//
//  ShareSivView.swift
//  IOS-idk
//
//  Created by Rachel Castor on 8/1/24.
//

import SwiftUI

struct ShareSivView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var appState = AppState.shared
    var showTabBarOnDismiss = true
    @Namespace var bottomId
    @State private var isProcessing = false

    @State var initialMessageForShare: String = ""
    @State var showGuestShare = false

    @State var showCreateGuest = false
    @State var showLinkShare = false

    @AppStorage("selectAllNotesDefault") var selectAllNotesDefault: Bool = false

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        ZStack {
                            Text("Share")
                                .font(Font.custom("Work Sans", size: 16))
                                .fontWeight(.medium)
                            HStack {

                                Spacer()
                            }
                        }.padding(.horizontal, 16)
                            .padding(.bottom, 27)

                        .padding(.horizontal, 16)
                        .padding(.bottom, 49)

                        VStack {
                            VStack {
                                shareLink
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .edgesIgnoringSafeArea(.all)
                        )
                        .onTapGesture {
                        }
                        Spacer().id(bottomId)

                    }
                }
                .frame(maxHeight: .infinity)
                .clipped()
            }

            VStack {
                Spacer()

            }
            .ignoresSafeArea(edges: .all)

        }
        .background(Color(.systemBackground)
            .edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }




    @State var shareLinkDetentFraction: PresentationDetent = .fraction(0.45)

    var shareLink: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(.lightGray))
                .frame(height: 0.7)

            HStack {
                Spacer()
                Button(action: {
                    showLinkShare.toggle()
                }) {
                    if isProcessing {
                        VStack(spacing: 6) {
                            Image(systemName: "checkmark")
                                .frame(width: 20, height: 20)
                            Text("Copied")
                        }
                    } else {
                        VStack(spacing: 6) {
                            Image(systemName: "link")
                            Text("Copy\nLink")
                        }
                    }
                }
                Spacer()


            }.padding(.horizontal, 16)
                .padding(.horizontal, 16)
                .padding(.top, 16) // 16
                .padding(.bottom, 34)

                .foregroundColor(.black)
        }
        .sheet(isPresented: $showLinkShare, onDismiss: {
            presentationMode.wrappedValue.dismiss()
        }, content: {
            CopyLinkSheet(shareLinkDetentFraction: $shareLinkDetentFraction)
                .presentationDetents([shareLinkDetentFraction])
                .presentationDragIndicator(.visible)
        })
    }

    @ObserveInjection var redraw
}

#Preview {
    ShareSivView()
}

struct CopyLinkSheet: View {
    @Binding var shareLinkDetentFraction: PresentationDetent

    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: CopyLinkSheetFocusFields?
    var basicEmojis: [String] = ["🚊", "✈️", "🎈", "📲", "🎁", "🏞️"]

    @State var memo = ""
    @State var selectedEmoji: String? = nil

    @State var copiedToClipboardButtonText: String = "Copied to Clipboard"
    @State var copiedToClipboard: Bool = false
    @ObserveInjection var redraw
    var body: some View {
        NavigationStack {
            VStack {
                header
                Divider()
                    .background(Color(.lightGray))
                    .frame(height: 0.7)
                identifyLater

                if selectedEmoji == nil {
                    basicReactionView
                }
                footer
                Spacer()
            }

            .onAppear {
                focusedField = .memo
            }
            .onChange(of: selectedEmoji) {
                shareLinkDetentFraction = (selectedEmoji == nil) ? .fraction(0.45) : .fraction(0.40)
//                if selectedEmoji == nil {
//                    shareLinkDetentFraction = .fraction(0.45)
//                } else {
//                    shareLinkDetentFraction = .fraction(0.35)
//                }
            }
        }
        .enableInjection()
    }
    @MainActor
    var header: some View {
        HStack {
            Spacer()
            VStack {
                Text("Context (Optional)")
                    .foregroundColor(.black)
                    .padding(.bottom, 12)
                Text("Write a brief memo about who you're sharing this with, why you're sending it, where you discussed it, etc., so you can you retrieve it later in your Activity Log.")
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
            }.padding(.horizontal, 32)
            Spacer()
        }
        .padding(.top, 42)
        .padding(.bottom, 12)
    }
    @MainActor
    var identifyLater: some View {
        HStack {
            if let selectedEmojiDisplay = selectedEmoji {
                Button(action: {
                    selectedEmoji = nil
                }, label: {
                    Text(selectedEmojiDisplay)
                    .padding(.trailing, 8)})
            }
            TextField("E.g. Sent to Ava, Kim's mom, at the park", text: $memo, axis: .vertical)
                .lineLimit(2 ... 5)
                .font(Font.custom("Work Sans", size: 14))
                .fontWeight(.regular)
                .focused($focusedField, equals: .memo)
                .padding(.vertical, 14)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(focusedField == .memo ? Color(.darkGray) : Color(.lightGray), lineWidth: focusedField == .memo ? 2 : 1)
                )
                .background(Color(.systemBackground))
                .frame(maxWidth: .infinity, alignment: .center)
        }.padding(.horizontal, 14)
    }

    var basicReactionView: some View {
        HStack {
            ForEach(basicEmojis, id: \.self) { emoji in
                Button(emoji) {
                    selectedEmoji = emoji
                }
                .font(.title)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedEmoji == emoji ? .orange : .clear)
                )
                Spacer()
            }

        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 68)
    }

    var footer: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(.gray))
                .frame(height: 0.7)
            HStack {
                Spacer()
                Button(action: {
                    let activityUUID = UUID()

                    UIPasteboard.general.string = ("https://www.youtube.com/watch?v=FPoKiGQzbSQ")

                    let notification = NotificationItem(message: "Link copied and saved to Activity Log", type: .newLinkCopy)
                    AppState.shared.addNotification(notification)
                    dismiss()
                }, label: {
                    Text("Copy Link")
                })
                Spacer()
            }.background(Color(.systemBackground))
        }
    }
}

// if let guestUUID =
//    UIPasteboard.general.string = "https://www.trysiv.com/shares/guest/\(guestUUID)/\(sivElementUUID)".lowercased()

enum CopyLinkSheetFocusFields: String, Identifiable, Hashable {
    var id: Self {
        self
    }

    case none
    case memo
}
