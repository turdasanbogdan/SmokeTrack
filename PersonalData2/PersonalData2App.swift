//
//  PersonalData2App.swift
//  PersonalData2
//
//  Created by bogdan on 13.04.2024.
//

import SwiftUI
import SwiftData

@main
struct PersonalData2App: App {
    
    var smokeStore = SmokeStore()
    var userProfileManager = UserProfileManager()
    var locationManager = LocationManager.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LandingPage()
                .environmentObject(smokeStore)
                .environmentObject(userProfileManager)
                .environmentObject(LocationManager.shared)
            
            let _ = WatchConnector(smokeStore: smokeStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
