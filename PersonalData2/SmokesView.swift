//
//  SmokesView.swift
//  PersonalData2
//
//  Created by bogdan on 14.04.2024.
//

import SwiftUI

struct SmokesView: View {
    @ObservedObject var smokeStore: SmokeStore
    @State var smokes: [Smoke] = generateMockData()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        

        NavigationView {
            
            List {
                Section(header: headerView("Today").font(.caption)) {
                    ForEach($smokeStore.smokes.filter { Calendar.current.isDateInToday($0.start.wrappedValue) }) { $smoke in
                        SmokeView(smoke: $smoke, onDeleteLevel: deleteSmoke)
                            
                    }
                }
                
                Section(header: Text("Previous 7 Days").font(.caption)) {
                    ForEach($smokeStore.smokes.filter { isDate($0.start.wrappedValue, inLastDays: 7) }) { $smoke in
                        SmokeView(smoke: $smoke, onDeleteLevel: deleteSmoke)
                    }
                }
                
                Section(header: Text("Previous 30 Days").font(.caption)) {
                    ForEach($smokeStore.smokes.filter { isDate($0.start.wrappedValue, inLastDays: 30) }) { $smoke in
                        SmokeView(smoke: $smoke, onDeleteLevel: deleteSmoke)
                    }
                }
            }

            .navigationBarTitle(Text("Smoking Stamps"))
            .padding(.top, 1)
            .padding(.bottom, 2)
            .font(.title2)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            })
           
        }

    }
    
    private func headerView(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .textCase(nil)
    }
    
    func deleteSmoke(_ smoke: Smoke) {
        smokeStore.deleteSmoke(smoke)
    }
    
    private func isDate(_ date: Date, inLastDays days: Int) -> Bool {
        let today = Date()
        let pastDate = Calendar.current.date(byAdding: .day, value: -days, to: today)!
        return date >= pastDate && date <= today
    }
}

struct SmokeView: View {
    
    @Binding var smoke: Smoke
    @State private var showingPopover = false
    @State private var emotionIcon: String?
    var onDeleteLevel: (Smoke) -> Void
    
    func mapEmotiontoIcon(emotion: String) -> String {
        let emotionMap: [String: String] = [
            "Angry": "ic-emoji-angry",
            "Sad": "ic-emoji-sad",
            "Smiley": "ic-emoji-smile",
            "Happy": "ic-emoji-happy",
            "Neutral": "ic-emoji-neutral"
        ]

        return emotionMap[emotion] ?? "ic-emoji-neutral"
    }
        
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()

    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

   
    var body: some View {
        HStack {
            
                    if let icon = emotionIcon {
                            Image(icon)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
            
                    VStack(alignment: .leading) {
                        Text("\(smoke.end, formatter: dateFormatter)")
                            .font(.body)
                        Text("\(smoke.end, formatter: timeFormatter)")
                            .font(.caption)
                    }
                    .padding()
                    Spacer()

                    Button(action: {
                        showingPopover = true
                    }) {
                        Image("ic-smokes-edit")
                    }
                    .popover(isPresented: $showingPopover) {
                        SmokeEditForm(smoke: $smoke, onDelete: onDeleteLevel)
                    }
                }
                    .onAppear {
                        emotionIcon = mapEmotiontoIcon(emotion: smoke.emotion ?? "")
                    }
                    .onChange(of: smoke.emotion) { newEmotion in
                        emotionIcon = mapEmotiontoIcon(emotion: newEmotion ?? "")
                    }
    }
    
    
}

struct SmokeEditForm: View {
    @Binding var smoke: Smoke
    @Environment(\.presentationMode) var presentationMode
    var onDelete: (Smoke) -> Void
    let emotions = ["Happy", "Smiley", "Neutral", "Sad", "Angry"]
    let environments = ["party", "study", "work", "sports", "other"]
    let socials = ["myself", "friends", "family", "other"]

    @State private var showingDeleteConfirm = false
    
    func systemImage(for emotion: String) -> String {
        switch emotion {
        case "Happy":
            return "ic-emoji-happy"
        case "Smiley":
            return "ic-emoji-smile"
        case "Neutral":
            return "ic-emoji-neutral"
        case "Sad":
            return "ic-emoji-sad"
        case "Angry":
            return "ic-emoji-angry"
        default:
            return "ic-emoji-neutral"
        }
    }
    
    func systemImageSocial(for social: String) -> String {
        switch social {
        case "myself":
            return "ic-social-alone"
        case "friends":
            return "ic-social-friends"
        case "family":
            return "ic-social-family"
        default:
            return "ic-social-other"
        }
    }
    
    func systemImageEnv(for env: String) -> String {
        switch env {
        case "party":
            return "ic-env-party"
        case "study":
            return "ic-env-study"
        case "work":
            return "ic-env-work"
        case "sports":
            return "ic-env-sports"
        default:
            return "ic-env-other"
        }
    }
    
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                
                
                Group {
                    Text("Time Stamp").font(.title3)
                    Text("Specify the start and end of your session").font(.footnote).foregroundColor(.gray)
                    DatePicker("Start", selection: $smoke.start)
                        .padding(2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .accentColor(Color("Teams"))
                    DatePicker("End", selection: $smoke.end)
                        .padding(2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .accentColor(Color("Teams"))
                }
                .padding([.top, .bottom], 5)

                Group {
                    Text("Smoke Count").font(.title3)
                    Text("Specify the quantity of cigarettes taken in the session").font(.footnote).foregroundColor(.gray)
                    HStack {
                        Text("Count")
                        Spacer()
                        Button(action: {
                            if smoke.cigarettesSmoked > 1 {
                                smoke.cigarettesSmoked -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.gray)
                        }
                        Text("\(smoke.cigarettesSmoked)")
                        Button(action: {
                            smoke.cigarettesSmoked += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.gray)
                                
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding([.top, .bottom], 5)

                Group {
                    Text("Emotional State").font(.title3)
                    Text("Specify the emotion that triggered the session").font(.footnote).foregroundColor(.gray)
                    Picker("Emotion", selection: $smoke.emotion) {
                        ForEach(emotions, id: \.self) { emotion in
                            HStack {
                                Image(systemImage(for: emotion))
                               
                                Text(emotion)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .tag(emotion as String?)
                        }
                    }  .accentColor(.purple)
                }
                .padding([.top, .bottom], 5)
             

                Group {
                    Text("Activity").font(.title3)
                    Text("Specify the activity that triggered the session").font(.footnote).foregroundColor(.gray)
                    Picker("Environment", selection: $smoke.environment) {
                        ForEach(environments, id: \.self) { environment in
                            HStack {
                                Image(systemImageEnv(for: environment))
                               
                                Text(environment)
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .tag(environment as String?)
                        }
                    }
                    .accentColor(.purple)
                }
                .padding([.top, .bottom], 5)

                Group {
                    Text("Social").font(.title3)
                    Text("Specify your company for the session").font(.footnote).foregroundColor(.gray)
                    Picker("Social Setting", selection: $smoke.social) {
                        ForEach(socials, id: \.self) { social in
                            HStack {
                                Image(systemImageSocial(for: social))
                                Spacer()
                                Text(social)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .tag(social as String?)
                        }
                    }
                    .accentColor(.purple)
                }
                .padding([.top, .bottom], 5)


                
                Button( action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    
                    Image("ic-button-edit-smoke")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                  
                }
            
                
                
                Button( action: {
                    showingDeleteConfirm = true
                }){
                    
                    Image("ic-button-delete-smoke")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(title: Text("Are you sure?"), message: Text("This will delete the smoke entry."), primaryButton: .destructive(Text("Delete")) {
                        onDelete(smoke)
                        presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .cancel())
                }
            }
            .padding()
        }
    }
}


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

