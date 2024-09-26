//
//  NetworkOfflineMessage.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 9/26/24.
//

import SwiftUI

struct NetworkOfflineMessage: View {
    var body: some View {
        ContentUnavailableView("You're Offline", systemImage: "wifi.slash", description: Text("Try again once you're back online"))
    }
}

#Preview {
    NetworkOfflineMessage()
}
