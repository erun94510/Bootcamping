//
//  Filtering.swift
//  BootCamping
//
//  Created by Donghoon Bae on 2023/02/06.
//

import Foundation

struct Filtering: Identifiable, Hashable {
    var id = UUID()
    var filterViewLocation: String
    var filters: [String]
    var filterNames: [String]
}