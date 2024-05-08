//
//  SocialSelectorView.swift
//  PersonalData2
//
//  Created by bogdan on 23.04.2024.
//

import SwiftUI

struct SocialSelectorView: View {
   
    @Binding var selectedSocial: String?
    
    let socials = [
        ("myself", "ic-social-alone"),
        ("friends", "ic-social-friends"),
        ("family", "ic-social-family"),
        ("other", "ic-social-other")
    ]
    
    var body: some View {
        VStack {
           
            HStack {
                            ForEach(socials.prefix(3), id: \.0) { social in
                                SocialButton(label: social.0, emoji: social.1, selectedSocial: $selectedSocial)
                            }
                        }
                        .padding(.bottom, 5)
                      
                        HStack {
                            SocialButton(label: socials[3].0, emoji: socials[3].1, selectedSocial: $selectedSocial)
                        }
        }
    }
}

struct SocialButton: View {
    var label: String
    var emoji: String
    @Binding var selectedSocial: String?
    
    var body: some View {
        Button(action: {
            selectedSocial = label
        }) {
            HStack(spacing: 4) { // Reduced spacing between elements
                            Image(emoji)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(label.capitalized)
                                .font(.system(size: 20))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(selectedSocial == label ? .white : .black)
            .background(selectedSocial == label ? Color("Teams") : Color("Teams3Background"))
            .cornerRadius(8)
        }
    }
}
