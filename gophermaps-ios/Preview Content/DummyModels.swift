//
//  DummyModels.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/12/24.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

let dummyArea = Components.Schemas.AreaModel(
                name: Components.Schemas.AreaModel.namePayload.init(value1: .EastBank),
                thumbnail: "dummy1.png"
)
