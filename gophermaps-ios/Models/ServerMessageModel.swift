//
//  ServerMessageModel.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/14/24.
//

import Foundation
import SwiftUICore

struct ServerMessageModel: Codable {
    let startDate: String
    let endDate: String
    let colors: [String]
    let title: String
    let body: String
    let id: String
    
    init?(jsonString: String) {
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("Error: Cannot convert JSON string to Data")
                return nil
            }
            
            do {
                // Decode the JSON data into the struct
                let decoder = JSONDecoder()
                self = try decoder.decode(ServerMessageModel.self, from: jsonData)
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
    }
    
    // Computed properties to convert string dates to Date objects
    var startDateObject: Date? {
        return dateFormatter.date(from: startDate)
    }
    
    var endDateObject: Date? {
        return dateFormatter.date(from: endDate)
    }
    
    // Computed property to check if message is active
    var isActive: Bool {
            guard let startDate = startDateObject, let endDate = endDateObject else {
                return false
            }
            let currentDate = Date()
            return currentDate >= startDate && currentDate <= endDate
        }
    
    /// Computed property for SwiftUI Color objects
    var colorObjects: [Color] {
        return colors.compactMap { colorFromHex($0) }
    }
    
    /// Helper for ``colorObjects``
    private func colorFromHex(_ hex: String) -> Color? {
            var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }
            
            var rgb: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgb)
            
            let red = Double((rgb >> 16) & 0xFF) / 255.0
            let green = Double((rgb >> 8) & 0xFF) / 255.0
            let blue = Double(rgb & 0xFF) / 255.0
            
            return Color(red: red, green: green, blue: blue)
    }
    
    // DateFormatter to handle the date conversion
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 format
        return formatter
    }
}
