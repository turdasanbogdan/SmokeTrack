//
//  LandingPage.swift
//  PersonalData2
//
//  Created by bogdan on 24.04.2024.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.top, 60)
                    .padding(.bottom, 30)

    
                Text("SmokeTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Teams"))

                Spacer()
                
                NavigationLink(destination: MultiStepForm()) {
                    Image("ic-get-started-button")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }
                .padding(.bottom, 5)
                .padding(.horizontal, 20)

                NavigationLink(destination: ContentView()) {
                    Image("ic-log-in-button")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 20)
            }
            .background(Color("Teams3Background"))
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
struct RegistrationForm: View {
    var body: some View {
      
        Text("Registration Form")
    }
}

struct Homepage: View {
    var body: some View {
       
        Text("Homepage")
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
