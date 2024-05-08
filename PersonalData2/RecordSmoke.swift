import SwiftUI
import MapKit


struct RecordSmoke: View {
    
    @State private var timeElapsed: TimeInterval = 0
    @State private var timerActive = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var showingToast = false
    @EnvironmentObject var smokeStore: SmokeStore
    @State private var selectedEmotion: String? = nil
    @State private var submitedEmotion: String? = nil
    @State private var toastMessage = ""
    @Binding var showRecordSmoke: Bool
    @EnvironmentObject var locationManager: LocationManager
    
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
            "ic-emoji-smile": "Smiley",
            "ic-emoji-happy": "Happy",
            "ic-emoji-neutral": "Neutral"
        ]

        return emotionMap[imageIdentifier] ?? "Unknown"
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
        
        NavigationStack {
            VStack {
                
                ZStack {
                    
                    Image("ic-timer-layer1")
                    Image("ic-timer-layer2")
                    Image("ic-timer-layer3")
                    
                    
                    Text(timeString(time: timeElapsed))
                        .font(.title)
                }
                .padding()
                .onReceive(timer) { _ in
                    if self.timerActive {
                        self.timeElapsed += 0.1
                    }
                }
                .onAppear {
                    startTimer()
                }
                
                Spacer()
                
                Text("Select Emotion")
                EmotionSelection(images: ["ic-emoji-angry", "ic-emoji-sad", "ic-emoji-neutral", "ic-emoji-smile", "ic-emoji-happy"], selectedEmotion: $selectedEmotion)
                
                
                
                
                VStack {
                    
                    Button(action: {
                        stopTimer()
                        endTime = Date()
                        startTime = endTime.addingTimeInterval(-timeElapsed)
                        submitedEmotion = mapImageToEmotion(imageIdentifier: selectedEmotion ?? "Unkown")
                        let newSmoke = Smoke(start: startTime, end: endTime, emotion: submitedEmotion, cigarettesSmoked: 1)
                        smokeStore.addSmoke(smoke: newSmoke)
                        toastMessage = "New Smoke Stamp created"
                        resetTimer()
                       
                        
                        showRecordSmoke = false
                        locationManager.appendLocation( CLLocationCoordinate2D(latitude: 55.6750, longitude: 12.5690))
                        
                        
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
                    }){
                        
                        Image("ic-button-cancel")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                       
                    }
                    
                }
                .padding()
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

