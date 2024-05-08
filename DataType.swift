//
//  DataType.swift
//  PersonalData2
//
//  Created by bogdan on 17.04.2024.
//

import Foundation

enum DataType: String, CaseIterable, Identifiable {
    case smokedCigarettes = "Smoked Cigarettes"
    case smokingDuration = "Smoking Duration"
    case mood = "Mood"

    var id: String { self.rawValue }
}
