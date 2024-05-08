//
//  StartingStampView.swift
//  PersonalData2
//
//  Created by bogdan on 07.05.2024.
//


import SwiftUI

struct StartingStampView: View {
    @Binding var showRecordSmoke: Bool
    @Binding var isActive: Bool
    @State private var activeIndex: Int = 0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var dots = ""

    var body: some View {
        VStack {
            Spacer()
            Text("Starting Stamp")
                .font(.largeTitle)
                .foregroundColor(Color("Teams"))

            HStack(spacing: 10) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color("Teams"))
                        .opacity(activeIndex == index ? 1 : 0.3)
                }
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    animateDots()
                }
            }
                

            Spacer()

            Button(action: {
                self.showRecordSmoke = false
                self.isActive = false
            }) {
                Image("ic-button-cancel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 120)
            }
            .padding(.bottom)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            RecordSmokeV2(showRecordSmoke: $showRecordSmoke, isActive: $isActive)
        }
    }
    
    func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            activeIndex = (activeIndex + 1) % 3
        }
    }
}

struct StartingStampView_Previews: PreviewProvider {
    static var previews: some View {
        StartingStampView(showRecordSmoke: .constant(true), isActive: .constant(true))
    }
}
