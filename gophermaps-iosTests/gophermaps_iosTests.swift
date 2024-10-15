//
//  gophermaps_iosTests.swift
//  gophermaps-iosTests
//
//  Created by Ryan Roche on 8/10/24.
//

import Foundation
import Testing
@testable import gophermaps_ios

extension Tag {
    @Tag static var network: Self
}


@Suite("Server Message Tests", .tags(.network)) struct ServerMessageTests {
    
    let currentDate: Date
    let calendar: Calendar
    let dayBefore: Date
    let yesterday: Date
    let tomorrow: Date
    let dayAfter: Date
    let dateFormatter: DateFormatter
    
    init() throws {
        // Get the current date
        currentDate = Date()
        
        // Create a Calendar instance
        calendar = Calendar.current
        
        // Add one day to the current date for the end date
        dayBefore = try #require(calendar.date(byAdding: .day, value: -2, to: currentDate))
        yesterday = try #require(calendar.date(byAdding: .day, value: -1, to: currentDate))
        tomorrow = try #require(calendar.date(byAdding: .day, value: 1, to: currentDate))
        dayAfter = try #require(calendar.date(byAdding: .day, value: 2, to: currentDate))
        
        // DateFormatter to format the dates
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 format
    }
    
    @Test func messageIsActive() throws {
        // Construct the JSON string
        let activeMessageData = """
        {
            "startDate": "\(dateFormatter.string(from: yesterday))",
            "endDate": "\(dateFormatter.string(from: tomorrow))",
            "colors": [
                "#FF5733",
                "#33FF57",
                "#3357FF"
            ],
            "title": "Inactive Message",
            "body": "This message should not be computed as active"
        }
        """
        let model = try #require(ServerMessageModel(jsonString: activeMessageData))
        #expect(model.isActive)
    }
    
    @Test(arguments: [
        (Calendar.current.date(byAdding: .day, value: -2, to: .now)!, Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        (Calendar.current.date(byAdding: .day, value: 1, to: .now)!, Calendar.current.date(byAdding: .day, value: 2, to: .now)!),
    ]) func messageIsInactive(start: Date, end: Date) throws {
        // Construct the JSON string
        let activeMessageData = """
        {
            "startDate": "\(dateFormatter.string(from: start))",
            "endDate": "\(dateFormatter.string(from: end))",
            "colors": [
                "#FF5733",
                "#33FF57",
                "#3357FF"
            ],
            "title": "Inactive Message",
            "body": "This message should not be computed as active"
        }
        """
        let model = try #require(ServerMessageModel(jsonString: activeMessageData))
        #expect(!model.isActive)
    }
}
