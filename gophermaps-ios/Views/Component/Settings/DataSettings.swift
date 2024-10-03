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
    
    @State private var vm = DataSettingsViewModel(context: context)
    
    init() {
        self.vm
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
                    Button("Delete Instruction Data", role:.destructive) { deleteInstructions() }
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

@Observable class DataSettingsViewModel {
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
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
    func deleteInstructions() {
        // Get URL to documents directory
        // Delete all contents of the instructions directory
    }
}

#Preview {
    DataSettingsView()
        .modelContainer(previewContainer)
}
