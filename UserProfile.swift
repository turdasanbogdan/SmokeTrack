//
//  UserProfile.swift
//  PersonalData2
//
//  Created by bogdan on 29.04.2024.
//


import Foundation

struct UserProfile {
    var name: String
    var surname: String
    var email: String
    var dateOfBirth: Date
    var productType: String
    var packingType: String
    var quantity: Int
    var price: Int
    var goal: String
    var consumption: Int
    var newTarget: Int
    var timeFrame: Int
   
    var age: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year ?? 0
    }
}
