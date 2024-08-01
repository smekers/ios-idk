//
//  NotificationMySivs.swift
//  IOS-idk
//
//  Created by Rachel Castor on 8/1/24.
//

import SwiftUI

struct NotificationMySivs: View {
    @State var dummyData: [String] = ["One", "Two", "Three"]
    var body: some View {
        refactored
    }
    
    @MainActor // diff
    var refactored: some View {
        NavigationStack {
            VStack {
                Text("Search")
                newFeedSection
            }
            .notificationBox()
        }
    }
    var newFeedSection: some View {
        VStack {
            ScrollViewReader { reader in
                ScrollView {
                    Text("Quickfilters")
                    LazyVStack {
                        ForEach(dummyData, id: \.self) { data in
                            NavigationLink {
                                Text("ElementDetailsView")
                            } label: {
                                HStack {
                                    Text(data)
                                    Spacer()
                                    NavigationLink {
                                        ShareSivView()
                                    } label: {
                                        Text("Share")
                                    }

                                }
                            }

                        }
                    }
                }
                
            }
        }
    }
    
}


#Preview {
    NotificationMySivs()
}


