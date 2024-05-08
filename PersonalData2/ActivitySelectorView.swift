//
//  ActivitySelectorView.swift
//  PersonalData2
//
//  Created by bogdan on 23.04.2024.
//

import SwiftUI

struct ActivitySelectorView: View {
   
    @Binding var selectedActivity: String?
    
    // Define the activities and corresponding emojis
//    let activities = [
//        ("party", "🎉"),
//        ("study", "📚"),
//        ("work", "💼"),
//        ("sports", "🏃"),
//        ("other", "🔄")
//    ]
    
    let activities = [
        ("party", "ic-env-party"),
        ("study", "ic-env-study"),
        ("work", "ic-env-work"),
        ("sports", "ic-env-sports"),
        ("other", "ic-env-other")
    ]
    
    var body: some View {
        VStack {
          
            HStack {
                ForEach(activities[0...2], id: \.0) { activity in
                    ActivityButton(label: activity.0, emoji: activity.1, selectedActivity: $selectedActivity)
                }
            }
            
           
            HStack {
                ForEach(activities[3...4], id: \.0) { activity in
                    ActivityButton(label: activity.0, emoji: activity.1, selectedActivity: $selectedActivity)
                }
            }
        }
    }
}

struct ActivityButton: View {
    var label: String
    var emoji: String
    @Binding var selectedActivity: String?
    
    var body: some View {
        Button(action: {
            selectedActivity = label
        }) {
            HStack(spacing: 4) {
                            Image(emoji)
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text(label.capitalized)
                                .font(.system(size: 20))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(selectedActivity == label ? .white : .black)
            .background(selectedActivity == label ? Color("Teams") : Color("Teams3Background"))
            .cornerRadius(8)
        }
    }
}

