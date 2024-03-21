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
        // MARK: Test objects
        // Node Numbers  : 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9
        // Node Buildings: 1 - 1 - 2 - 3 - 3 - 3 - 4 - 4 - 5
        let testNode1 = BuildingEntry(name: "Test Building 1", navID: "tb1a", thumbnail: "kellerHall")
        let testNode2 = GraphNode(name: "Test Building 1", navID: "tb1b")
        let testNode3 = BuildingEntry(name: "Test Building 2", navID: "tb2a", thumbnail: "kellerHall")
        let testNode4 = BuildingEntry(name: "Test Building 3", navID: "tb3a", thumbnail: "kellerHall")
        let testNode5 = GraphNode(name: "Test Building 3", navID: "tb3b")
        let testNode6 = GraphNode(name: "Test Building 3", navID: "tb3c")
        let testNode7 = BuildingEntry(name: "Test Building 4", navID: "tb4a", thumbnail: "kellerHall")
        let testNode8 = GraphNode(name: "Test Building 4", navID: "tb4b")
        let testNode9 = BuildingEntry(name: "Test Building 5", navID: "tb5a", thumbnail: "kellerHall")
        
        // MARK: Test Code
        let testRoute: [PathStep] = [testNode1, testNode2, testNode3, testNode4, testNode5, testNode6, testNode7, testNode8, testNode9]
        let resultBuildings = getBuildingsFromRoute(route: testRoute)
        let solutionBuildings = [testNode1, testNode3, testNode4, testNode7, testNode9]
        XCTAssertEqual(resultBuildings, solutionBuildings)
    }
    
    func testPingServer() async {
        do {
            let res = try await Backend.pingServer(ip: "1.1.1.1")
            XCTAssertTrue(res)
        } catch {
            XCTFail("pingServer threw an error: \(error)")
        }
    }
}
