//
//  CompletionView.swift
//  PersonalData2
//
//  Created by bogdan on 07.05.2024.
//

import Foundation
import SwiftUI

struct CompletionView: View {
    @Binding var isActiveComplete: Bool
    @State private var scale: CGFloat = 1.0
    @Binding var isActive:Bool
    @Binding var showRecordSmoke: Bool
    
    var body: some View {
        ZStack {
            Color("Teams3Background").opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Stamp Completed")
                    .font(.title)
                    .foregroundColor(Color("Teams2"))
                    .padding()
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color("Teams"))
                    .scaleEffect(scale)
                    .onAppear {
                        // Execute the animation
                        let baseAnimation = Animation.easeInOut(duration: 1)
                        withAnimation(baseAnimation.repeatForever(autoreverses: true)) {
                            scale = 1.2
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            
                            isActive = false
                            showRecordSmoke = false
                            
                        }

                       
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                           
                            isActiveComplete = false
                        }
                    }
            }
        }
    }
}


