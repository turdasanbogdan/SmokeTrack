//
//  UserProfileManager.swift
//  PersonalData2
//
//  Created by bogdan on 01.05.2024.
//

import Combine
import SwiftUI

class UserProfileManager: ObservableObject {
    @Published var userProfile: UserProfile
    
    init(userProfile: UserProfile = UserProfile(name: "", surname: "", email: "",
                                                dateOfBirth: Date(), productType: "",
                                                packingType: "", quantity: 0,
                                                price: 0, goal: "", consumption: 0,
                                                newTarget: 0, timeFrame: 0)) {
        self.userProfile = userProfile
    }
    
    func updateAllUserProfileDetails(with profile: UserProfile) {
        updateName(profile.name)
        updateSurname(profile.surname)
        updateEmail(profile.email)
        updateDateOfBirth(profile.dateOfBirth)
        updateProductType(profile.productType)
        updatePackingType(profile.packingType)
        updateQuantity(profile.quantity)
        updatePrice(profile.price)
        updateGoal(profile.goal)
        updateConsumption(profile.consumption)
        updateNewTarget(profile.newTarget)
        updateTimeFrame(profile.timeFrame)
    }
    
    // Update name
    func updateName(_ name: String) {
        userProfile.name = name
    }
    
    // Update surname
    func updateSurname(_ surname: String) {
        userProfile.surname = surname
    }
    
    // Update email
    func updateEmail(_ email: String) {
        userProfile.email = email
    }
    
    // Update date of birth
    func updateDateOfBirth(_ date: Date) {
        userProfile.dateOfBirth = date
    }
    
    // Update product type
    func updateProductType(_ type: String) {
        userProfile.productType = type
    }
    
    // Update packing type
    func updatePackingType(_ type: String) {
        userProfile.packingType = type
    }
    
    // Update quantity
    func updateQuantity(_ quantity: Int) {
        userProfile.quantity = quantity
    }
    
    // Update price
    func updatePrice(_ price: Int) {
        userProfile.price = price
    }
    
    // Update goal
    func updateGoal(_ goal: String) {
        userProfile.goal = goal
    }
    
    // Update current consumption
    func updateConsumption(_ consumption: Int) {
        userProfile.consumption = consumption
    }
    
    // Update new target
    func updateNewTarget(_ target: Int) {
        userProfile.newTarget = target
    }
    
    // Update time frame
    func updateTimeFrame(_ timeFrame: Int) {
        userProfile.timeFrame = timeFrame
    }
}
