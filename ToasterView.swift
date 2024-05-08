//
//  ToasterView.swift
//  PersonalData2
//
//  Created by bogdan on 15.04.2024.
//

import SwiftUI

struct ToastView: View {
    var text: String
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            Text(text)
                .padding()
                .background(Color.secondary)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.5), value: isShowing)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
        }
    }
}
