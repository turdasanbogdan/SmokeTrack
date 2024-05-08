//
//  RecordSmokeV2.swift
//  PersonalData2
//
//  Created by bogdan on 23.04.2024.
//

import SwiftUI
import MapKit

struct RecordSmokeV2: View {
    
    @State private var timeElapsed: TimeInterval = 0
    @State private var timerActive = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var showingToast = false
    @EnvironmentObject var smokeStore: SmokeStore
    @State private var selectedEmotion: String? = nil
    @State private var submitedEmotion: String? = nil
    @State private var selectedSocial: String? = nil
    @State private var selectedActivity: String? = nil
    @State private var toastMessage = ""
    @Binding var showRecordSmoke: Bool
    @State private var cigarettesSmoked = 1
    @EnvironmentObject var locationManager: LocationManager
    @Binding var isActive: Bool
    @State private var showCompletionView = false
    @State private var showDetailPopup = false
    @State private var isAnimating = false
    
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func mapImageToEmotion(imageIdentifier: String) -> String {
        let emotionMap: [String: String] = [
            "ic-emoji-angry": "Angry",
            "ic-emoji-sad": "Sad",
            "ic-emoji-smile": "Smiley",  // Assuming you want the same value for both "smile" entries
            "ic-emoji-happy": "Happy",
            "ic-emoji-neutral": "Neutral"
        ]

        return emotionMap[imageIdentifier] ?? "Unknown"  // Return "Unknown" or any other default value if not found
    }
    
    private func startTimer() {
        timerActive = true
    }

    private func stopTimer() {
        timerActive = false
    }

    private func resetTimer() {
        timeElapsed = 0
    }

    var body: some View {
        
        VStack{
            
            
            Text("Recording your smoking session")
                    .font(.caption2)
                    .foregroundColor(Color("Teams2"))
                    .padding(.top, 50)
            
            Spacer()
            
            
            ZStack {
                            
                            Circle()
                                .stroke(lineWidth: 25)
                                .foregroundColor(Color("Teams"))
                                .frame(width: 120, height: 120)
                                .scaleEffect(isAnimating ? 1.2 : 1)
                                .opacity(isAnimating ? 0.05 : 1)
                                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses:false).speed(0.5))
                                .onAppear {
                                    self.isAnimating.toggle()
                                }

                           
                            Text("\(cigarettesSmoked)")
                                .font(.system(size: 100, weight: .bold))
                        }
            
            .padding(.top, 150)
            
            HStack(spacing: 120) {
                Button(action: {
                    if cigarettesSmoked > 0 {
                        cigarettesSmoked -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(Color("Teams"))
                }

                Button(action: {
                    cigarettesSmoked += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(Color("Teams"))
                }
            }
            .padding(.top, 50)
            
            Text("Number of cigarettes smoked")
                    .font(.body)
                    .foregroundColor(Color("Teams"))
                    .padding(.top, 50)
            
            
        }
        
        Spacer()
 
        
        NavigationStack {
            VStack {
                


              
                
                VStack {
                    
                    Button(action: {
                       
                        showDetailPopup = true
                                            
                        
                    }) {
                        Image("ic-button-submit-stamp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                      
                    }
                    .overlay(
                        ToastView(text: toastMessage, isShowing: $showingToast),
                        alignment: .bottom
                    )
                    
                    Button( action: {
                        stopTimer()
                        resetTimer()
                        showRecordSmoke = false
                        isActive = false
                    }){
                        
                        Image("ic-button-cancel")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                
                    }
                    
                }
                .sheet(isPresented: $showDetailPopup) {
                    AdditionalDetailsView(selectedEmotion: $selectedEmotion, selectedActivity: $selectedActivity, selectedSocial: $selectedSocial, showPopup: $showDetailPopup, timeElapsed: $timeElapsed, cigarettesSmoked: $cigarettesSmoked,showCompletionView: $showCompletionView, timerActive: $timerActive)
                                }
                .padding()
            }
            .onReceive(timer) { _ in
                if self.timerActive {
                    self.timeElapsed += 0.1
                }
            }
            .onAppear {
                startTimer()
            }
            .fullScreenCover(isPresented: $showCompletionView) {
                            CompletionView(isActiveComplete: $showCompletionView, isActive: $isActive, showRecordSmoke: $showRecordSmoke)
                }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button( action: {
                    showRecordSmoke = false
                }){
                    Image("ic-go-back")
                                .resizable()
                                .frame(width: 24, height: 24)
                }
            }
            
            ToolbarItem(placement: .principal){
                Text("New Smoking Stamp").font(.title2)
            }
            
        }
    }
    

    // Sample emoji list
    private let emojis = ["😀", "😂", "😍", "😭", "🥺"]
}


struct AdditionalDetailsView: View {
    @Binding var selectedEmotion: String?
    @Binding var selectedActivity: String?
    @Binding var selectedSocial: String?
    @Binding var showPopup: Bool
    @EnvironmentObject var smokeStore: SmokeStore
    @EnvironmentObject var locationManager: LocationManager
    @State private var startTime = Date()
    @State private var endTime = Date()
    @Binding var timeElapsed: TimeInterval
    @Binding var cigarettesSmoked: Int
    @Binding var showCompletionView: Bool
    @Binding var timerActive: Bool
    

   
    @State private var showingConfirmationDialog = false

    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Group {
                    
                    Text("What is your mood?")
                        .font(.headline)
                        .foregroundColor(Color("Teams"))
                        .padding(.top, 40)
                    EmotionSelectorView(selectedEmotion: $selectedEmotion)
                        
                    Spacer()

                    Text("What is your activity?")
                        .font(.headline)
                        .foregroundColor(Color("Teams"))
                    ActivitySelectorView(selectedActivity: $selectedActivity)
                        
                    
                    Spacer()


                    Text("Who are you with?")
                        .font(.headline)
                        .foregroundColor(Color("Teams"))
                    SocialSelectorView(selectedSocial: $selectedSocial)
                        .padding(.bottom, 40)
                    
                    Spacer()
                }

                Spacer()

                Button(action: {
                   
                    showingConfirmationDialog = true
                }) {
                    Image("ic-button-submit-stamp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .confirmationDialog("Are you sure you want to submit this smoking session?", isPresented: $showingConfirmationDialog, titleVisibility: .visible) {
                    Button("Yes", role: .destructive) {
                        submitData()
                    }
                    Button("No", role: .cancel) {}
                }
                .padding()
            }
            .navigationBarTitle("Additional Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showPopup = false
            }) {
                
                HStack{
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                    
                }
               
            })
        }
    }

    func submitData() {
        endTime = Date()
        startTime = endTime.addingTimeInterval(-timeElapsed)
        let newSmoke = Smoke(start: startTime, end: endTime, emotion: selectedEmotion, environment: selectedActivity, social: selectedSocial, cigarettesSmoked: cigarettesSmoked)

        print(newSmoke)
        smokeStore.addSmoke(smoke: newSmoke)
        locationManager.appendLocation( CLLocationCoordinate2D(latitude: 55.7859, longitude: 12.5254))

        timeElapsed = 0
        timerActive = false
        showPopup = false
        showCompletionView = true
    }
}










