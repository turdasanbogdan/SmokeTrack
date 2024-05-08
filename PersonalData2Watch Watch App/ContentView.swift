import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var navigateToTimerView = false
    @State private var timerIsActive = false
    @State private var timeElapsed: TimeInterval = 0.0

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            if navigateToTimerView {
                TimerView(timerIsActive: $timerIsActive, timeElapsed: $timeElapsed)
            } else {
                VStack {
                    Text("Smoking session")
                    
                    Button(action: {
                        navigateToTimerView = true
                        timerIsActive = true // Make sure to activate the timer
                    }) {
                        Image("ic-start-timer-watch")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .opacity(1.0)
                    }
                }
                .onReceive(timer) { _ in
                    if timerIsActive {
                        timeElapsed += 0.1
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct TimerView: View {
    @State private var navigateToSelectEmotion = false
    @Binding var timerIsActive: Bool
    @Binding var timeElapsed: Double
    @State private var dots = ""
    @State private var navigateBack = false
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var showConfirmation = false

    private func updateDots() {
        if dots.count < 3 {
            dots += "."
        } else {
            dots = ""
        }
    }
    
    var body: some View {

        if navigateBack {
            ContentView()
        }else{
            
            
            ZStack {
                if navigateToSelectEmotion {
                    SelectEmotionView(timeElapsed: $timeElapsed, timerIsActive: $timerIsActive)
                } else {
                    
                    VStack{
                        
                        HStack{
                            Text("Recording")
                                .font(.caption)
                                .foregroundColor(Color("Teams"))
                            Text(dots)
                                .font(.caption)
                                .foregroundColor(Color("Teams"))
                                .onReceive(timer) { _ in
                                    updateDots()
                                }
                            Spacer()
                            
                            Button(action:{
                                showConfirmation = true
                            }){
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 25))
                                    .foregroundColor(.red)
                                    
                            }
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Are you sure?"),
                                      message: Text("This smoking stamp will be deleted"),
                                      primaryButton: .destructive(Text("Yes")) {
                                       
                                        navigateBack = true
                                        timerIsActive = false
                                      },
                                      secondaryButton: .cancel()
                                )
                            }
                        }
                        
                        
                        Button(action: {
                            
                            navigateToSelectEmotion = true
                            timerIsActive = false
                        }) {
                            Image("ic-timer")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .opacity(1.0)
                        }
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
                
    }
}

struct SelectEmotionView: View {
    
    @State private var navigateBack = false
    @State private var navigateToFinal = false
    @Binding var timeElapsed: Double
    @Binding var timerIsActive: Bool
    @State private var selectedEmotion: String? = nil
    @State private var submitedEmotion: String? = nil
    @EnvironmentObject var smokeStore: SmokeStore
    @State private var startTime = Date()
    @State private var endTime = Date()
    @StateObject var watchConnector = WatchToIOSConnector()
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied because: \(error.localizedDescription).")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Confirmation"
        content.body = "Smoke Session Registered"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
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
        timerIsActive = true
    }

    private func stopTimer() {
        timerIsActive = false
    }

    private func resetTimer() {
        timeElapsed = 0
    }
    
    func sendSmokeToIOS(smoke:Smoke){
        
        watchConnector.sendSmokeToIOS(smoke: smoke)
        
    }
    
    private func formatDate(_ date: Date) -> String {
          let formatter = DateFormatter()
          formatter.timeStyle = .short
          return formatter.string(from: date)
      }

  

    var body: some View {
        ZStack {
            if navigateBack {
                ContentView()
            } else {
                
                VStack{
                    
       
                             Text("Smoking Session")
                                 .font(.title3)
                                 .foregroundColor(Color("Teams")) 
                                 .padding()

                             Text("Start Time: \(formatDate(startTime))")
                                 .font(.headline)
                                 .foregroundColor(Color("Teams3Background"))



                             
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack{
                        
                        Button(action: {
                            navigateBack = true
                        }) {
                            Image("ic-cancel-watch")
                                .resizable()
                                .frame(width: 100, height: 85)
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            stopTimer()
                            endTime = Date()
                            startTime = endTime.addingTimeInterval(-timeElapsed)
                            submitedEmotion = mapImageToEmotion(imageIdentifier: selectedEmotion ?? "Unkown")
                            let newSmoke = Smoke(start: startTime, end: endTime, emotion: submitedEmotion, cigarettesSmoked: 1)
                            sendSmokeToIOS(smoke: newSmoke)
                            scheduleNotification()
                            navigateBack = true
                        }) {
                            Image("ic-submit-watch")
                                .resizable()
                                .frame(width: 100, height: 85)
                        }
                    }
                }

            }
        }

    }

    
    
}


struct SelectEmotionView_Previews: PreviewProvider {
    @State static var timeElapsed = 0.0
    @State static var isActive = false
    
    static var previews: some View {
        SelectEmotionView(timeElapsed: $timeElapsed, timerIsActive: $isActive)
            .environmentObject(SmokeStore()) // Assuming SmokeStore is your environment object
    }
}

struct TimerView_Previews: PreviewProvider {
    @State static var isActive = true
    @State static var timeElapsed = 0.0
    
    static var previews: some View {
        TimerView(timerIsActive: $isActive, timeElapsed: $timeElapsed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
