//
//  TimeFrame.swift
//  PersonalData2
//
//  Created by bogdan on 17.04.2024.
//

import Foundation

enum TimeFrame: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { self.rawValue }
}

