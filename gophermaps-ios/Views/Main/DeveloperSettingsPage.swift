//
//  DeveloperSettingsPage.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/18/24.
//

import SwiftUI

enum apiServerPingState {
    case unknown
    case waiting
    case failed
    case succeeded
}

struct AreasApiTestResult: View {
    @State var waiting = true
    @State var apiSuccess = false
    @State var response: [String] = []
    
    var body: some View {
        if waiting {
            ProgressView().task{
                do {
                    response = try await Backend.getAreas()
                    waiting = false
                    apiSuccess = true
                } catch {
                    waiting = false
                }
            }
        } else {
            List(response, id:\.self) { area in
                Text(area)
            }
        }
    }
}

struct BuildingsApiTestResult: View {
    let area: String
    
    @State var waiting = true
    @State var response: [BuildingEntry] = []
    
    var body: some View {
        if waiting {
            ProgressView().task{
                do {
                    response = try await Backend.getBuildings(area: area)
                    waiting = false
                } catch {
                    response = [BuildingEntry(name:"Request Failed", navID:"", thumbnail:"")]
                    waiting = false
                }
            }
        } else {
            List {
                ForEach(response.sorted{$0.name < $1.name}, id:\.self) { building in
                    Section {
                        LabeledContent("name") { Text(building.name) }
                        LabeledContent("navID") { Text(building.navID) }
                        LabeledContent("thumbnail") { Text(building.thumbnail) }
                    }
                }
            }.listStyle(.insetGrouped)
        }
    }
}

struct DestinationsApiTestResult: View {
    let building: BuildingEntry
    
    @State var waiting = true
    @State var response: [BuildingEntry] = []
    
    var body: some View {
        if waiting {
            ProgressView().task{
                do {
                    response = try await Backend.getDestinations(start: building)
                    waiting = false
                } catch {
                    response = []
                    waiting = false
                }
            }
        } else {
            List(response, id:\.self) { entry in
                Section {
                    Text(entry.name)
                    Text(entry.navID)
                    Text(entry.thumbnail)
                }
            }.listStyle(.insetGrouped)
        }
    }
}

struct RoutesApiTestResult: View {
    let start: BuildingEntry
    let end: BuildingEntry
    
    @State var waiting = true
    @State var response: [any PathStep] = []
    @State var dataDownloadStatus: apiServerPingState = .unknown
    
    var body: some View {
        if waiting {
            ProgressView().task{
                do {
                    response = try await Backend.getRoute(start: start, end: end)
                    waiting = false
                } catch {
                    print(error)
                    response = []
                    waiting = false
                }
            }
        } else {
            if response.isEmpty {
                Text("Something went wrong")
            } else {
                List {
                    ForEach(response, id:\.self.name) { entry in
                        Section {
                            Text(entry.name)
                            Text(entry.navID)
                        }
                    }
                    HStack  {
                        Button("Download Route Data") {
                            print("Downloading...")
                            Task {
                                if await BackendStubs.downloadRouteData(route: response) {
                                    dataDownloadStatus = .succeeded
                                } else {
                                    dataDownloadStatus = .failed
                                }
                                dataDownloadStatus = .waiting
                            }
                        }
                        Spacer()
                        switch(dataDownloadStatus) {
                        case .succeeded:
                            Image(systemName: "checkmark")
                        case .failed:
                            Image(systemName: "xmark")
                        case .waiting:
                            ProgressView()
                        case .unknown:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
}

struct DeveloperSettingsPage: View {
    @AppStorage("goButtonOnLeft") var goButtonOnLeft: Bool = true
    @AppStorage("serverAddress") var serverAddress: String = "placeholder"
    
    @State var apiServerPingStatus: apiServerPingState = .unknown
    
    let apiAreaChoices = ["TestBuildings", "EastBank"]
    @State var apiAreaSelection = "TestBuildings"
    
    let apiBuildingChoices = [
        BuildingEntry(name: "t1a", navID: "t1a", thumbnail: ""),
        BuildingEntry(name: "t2a", navID: "t2a", thumbnail: ""),
        BuildingEntry(name: "t3a", navID: "t3a", thumbnail: "")
    ]
    @State var apiBuildingSelection = BuildingEntry(name:"t1a", navID: "t1a", thumbnail:"")
    
    @State var apiStartSelection = BuildingEntry(name:"t1a", navID: "t1a", thumbnail:"")
    @State var apiEndSelection = BuildingEntry(name:"t3a", navID: "t3a", thumbnail:"")

    
    var body: some View {
        List {
            Section("API Tests") {
                // MARK: "Ping Server" button
                HStack {
                    Button("Ping API Server") {
                        Task {
                            do {
                                print("Attempting to ping \(serverAddress):8080/docs... ", terminator:"")
                                let res = try await Backend.pingServer(ip:"\(serverAddress):8080/docs")
                                if res {
                                    apiServerPingStatus = .succeeded
                                    print("✅ Succeeded!")
                                } else {
                                    apiServerPingStatus = .failed
                                    print("❌ Failed")
                                }
                                
                                apiServerPingStatus = res ? .succeeded : .failed
                            } catch {
                                print("pingServer threw \(error)")
                                apiServerPingStatus = .failed
                            }
                        }
                        apiServerPingStatus = .waiting
                    }
                    Spacer()
                    switch(apiServerPingStatus) {
                    case .succeeded:
                        Image(systemName: "checkmark")
                    case .failed:
                        Image(systemName: "xmark")
                    case .waiting:
                        ProgressView()
                    case .unknown:
                        EmptyView()
                    }
                }
                
                // MARK: /areas
                NavigationLink {
                    AreasApiTestResult()
                } label: {
                    Text("/areas")
                }
                
                // MARK: /buildings
                NavigationLink {
                    BuildingsApiTestResult(area: apiAreaSelection)
                } label: {
                    HStack(spacing:0) {
                        Text("/buildings/")
                        Picker("foo", selection:$apiAreaSelection) {
                            ForEach(apiAreaChoices, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.menu).labelsHidden().padding(.leading, -10)
                    }
                }
                
                // MARK: /destinations
                NavigationLink {
                    DestinationsApiTestResult(building: apiBuildingSelection)
                } label: {
                    HStack {
                        Text("/destinations/")
                        Picker("foo", selection:$apiBuildingSelection) {
                            ForEach(apiBuildingChoices, id: \.self) {
                                Text($0.navID)
                            }
                        }.pickerStyle(.menu).labelsHidden().padding(.leading, -16)
                    }
                }
                
                // MARK: /routes
                NavigationLink {
                    RoutesApiTestResult(start: apiStartSelection, end: apiEndSelection)
                } label: {
                    HStack {
                        Text("/routes/")
                        Picker("foo", selection:$apiStartSelection) {
                            ForEach(apiBuildingChoices, id: \.self) {
                                Text($0.navID)
                            }
                        }.pickerStyle(.menu).labelsHidden().padding(.leading, -16)
                        Text("-")
                        Picker("foo", selection:$apiEndSelection) {
                            ForEach(apiBuildingChoices, id: \.self) {
                                Text($0.navID)
                            }
                        }.pickerStyle(.menu).labelsHidden().padding(.leading, -16)
                    }
                }
            }
            
            Section("Raw Userdefaults") {
                Toggle(isOn: $goButtonOnLeft, label: {Text("goButtonOnLeft")})
                HStack {
                    Text("serverAddress")
                    TextField("0.0.0.0", text: $serverAddress).multilineTextAlignment(.trailing)
                }
            }
        }
    }
}

#Preview {
    UserDefaults.standard.register(defaults: [
        "goButtonOnLeft" : true,
        "serverAddress" : "128.101.131.206"
    ])
    return NavigationStack {
        DeveloperSettingsPage().navigationTitle("Developer")
    }
}
