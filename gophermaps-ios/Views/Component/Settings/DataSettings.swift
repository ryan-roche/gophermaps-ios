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
    @State var confirmDeleteInstructions: Bool = false
    
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
    
    func deleteInstructions() async {
        do {
            try await DownloadManager.shared.clearDownloadedInstructions()
        } catch {
            print("Failed to clear instructions! \(error)")
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
            
            // MARK: Clear Downloaded Instructions
            Button(role: .destructive,
                   action: {confirmDeleteInstructions.toggle()},
                   label: {Text("Clear Downloaded Instructions")})
                .confirmationDialog("Delete all downloaded instruction data?",
                    isPresented: $confirmDeleteInstructions) {
                    Button("Delete Instruction Data", role:.destructive) {
                        Task {
                            await deleteInstructions()
                        }
                    }
                    Button("Cancel", role:.cancel) {}
                } message: {
                    Text("Are you sure you want to delete all downloaded instruction data? You will need to redownload any instructions in order to view them again.")
                }
        }
#if DEBUG
        Text("\(routes.count) Saved Routes")
#endif
    }
}

#if DEBUG
#Preview {
    DataSettingsView()
        .modelContainer(previewContainer)
}
#endif
