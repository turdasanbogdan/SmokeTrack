//
//  Item.swift
//  PersonalData2
//
//  Created by bogdan on 13.04.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
