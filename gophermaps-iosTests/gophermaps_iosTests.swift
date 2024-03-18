//
//  gophermaps_iosTests.swift
//  gophermaps-iosTests
//
//  Created by Ryan Roche on 2/29/24.
//

import XCTest
@testable import gophermaps_ios

final class gophermaps_iosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBuildingsFromRoute() {
        // MARK: BuildingEntry objects
        let testBuilding1 = BuildingEntry(name: "Test Building 1", thumbnail: .PlaceholderBuildings.kellerHall)
        let testBuilding2 = BuildingEntry(name: "Test Building 2", thumbnail: .PlaceholderBuildings.kellerHall)
        let testBuilding3 = BuildingEntry(name: "Test Building 3", thumbnail: .PlaceholderBuildings.kellerHall)
        let testBuilding4 = BuildingEntry(name: "Test Building 4", thumbnail: .PlaceholderBuildings.kellerHall)
        let testBuilding5 = BuildingEntry(name: "Test Building 5", thumbnail: .PlaceholderBuildings.kellerHall)
        
        // MARK: GraphNode objects
        // Node Numbers  : 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9
        // Node Buildings: 1 - 1 - 2 - 3 - 3 - 3 - 4 - 4 - 5
        let testNode1 = GraphNode(nodeID: "tb1a", building: testBuilding1)
        let testNode2 = GraphNode(nodeID: "tb1b", building: testBuilding1)
        let testNode3 = GraphNode(nodeID: "tb2a", building: testBuilding2)
        let testNode4 = GraphNode(nodeID: "tb3a", building: testBuilding3)
        let testNode5 = GraphNode(nodeID: "tb3b", building: testBuilding3)
        let testNode6 = GraphNode(nodeID: "tb3c", building: testBuilding3)
        let testNode7 = GraphNode(nodeID: "tb4a", building: testBuilding4)
        let testNode8 = GraphNode(nodeID: "tb4b", building: testBuilding4)
        let testNode9 = GraphNode(nodeID: "tb5a", building: testBuilding5)
        
        // MARK: Test Code
        let testRoute = [testNode1, testNode2, testNode3, testNode4, testNode5, testNode6, testNode7, testNode8, testNode9]
        let resultBuildings = getBuildingsFromRoute(route: testRoute)
        XCTAssertEqual(resultBuildings, [testBuilding1, testBuilding2, testBuilding3, testBuilding4, testBuilding5])
    }

    func testMdFilenameGeneration() {
        let testRoute = previewShortNavRoute
        
    }
}
