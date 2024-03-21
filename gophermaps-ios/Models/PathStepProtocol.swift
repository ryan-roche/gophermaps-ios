//
//  PathStepProtocol.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/21/24.
//

import SwiftUI

protocol PathStep: Codable {
    var name: String { get }
    var navID: String { get }
}
