//
//  DataManagementPage.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 9/26/24.
//

import SwiftUI
import SwiftData

struct DataSettingsView: View {
    
#if DEBUG
    @Query var routes: [SavedRoute]
#endif
    
    @Environment(\.modelContext) var context
    
    @State var confirmDeleteSavedRoutes: Bool = false
    
    func deleteSavedRoutes() {
        let fd = FetchDescriptor<SavedRoute>()
        
        do {
            let results = try context.fetch(fd)
            for object in results {
                context.delete(object)
            }
            
            try context.save()
        
        } catch {
            print("Failed to delete SavedRoute objects: \(error)")
        }
    }
    
    var body: some View {
        List {
            // MARK: Delete All Saved Routes
            Button(role: .destructive,
                   action: {confirmDeleteSavedRoutes.toggle()},
                   label: {Text("Delete Saved Routes")})
                .confirmationDialog("Delete All Saved Routes?",
                    isPresented: $confirmDeleteSavedRoutes) {
                    Button("Delete Saved Routes", role:.destructive) { deleteSavedRoutes() }
                    Button("Cancel", role:.cancel) {}
                } message: {
                    Text("Are you sure you want to delete all saved routes?")
                }
        }
#if DEBUG
        Text("\(routes.count) Saved Routes")
#endif
    }
}

#Preview {
    DataSettingsView()
        .modelContainer(previewContainer)
}
