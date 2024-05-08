//
//  EmotionSelectorView.swift
//  PersonalData2
//
//  Created by bogdan on 01.05.2024.
//



import SwiftUI

struct EmotionSelectorView: View {
    
    @Binding var selectedEmotion: String?
    
   
    let emotions = [
        ("Happy", "😀"),
        ("Smiley", "😊"),
        ("Neutral", "😐"),
        ("Angry", "😡"),
        ("Sad", "😢")
    ]
    var body: some View {
        VStack {
        
            HStack {
                ForEach(emotions[0...2], id: \.0) { activity in
                    EmotionButton(label: activity.0, emoji: activity.1, selectedEmotion: $selectedEmotion)
                }
            }
            
           
            HStack {
                ForEach(emotions[3...4], id: \.0) { activity in
                    EmotionButton(label: activity.0, emoji: activity.1, selectedEmotion: $selectedEmotion)
                }
            }
        }
    }
}

struct EmotionButton: View {
    var label: String
    var emoji: String
    @Binding var selectedEmotion: String?
    
    var body: some View {
        Button(action: {
            selectedEmotion = label
        }) {
            HStack(spacing: 4) {
                            Text(emoji)
                                .font(.system(size: 20))
                            Text(label.capitalized)
                                .font(.system(size: 20))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(selectedEmotion == label ? .white : .black)
            .background(selectedEmotion == label ? Color("Teams") : Color("Teams3Background"))
            .cornerRadius(8)
        }
    }
}
