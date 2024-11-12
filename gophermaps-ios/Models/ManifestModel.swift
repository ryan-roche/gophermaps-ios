//
//  ManifestModel.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 11/4/24.
//

import Foundation

struct ManifestModel: Codable {
    let instructions: [String: InstructionSet]
    let serverMessages: [ServerMessageModel]
    
    struct InstructionSet: Codable {
        let last_modified: String
        let files: [String]
    }
}
