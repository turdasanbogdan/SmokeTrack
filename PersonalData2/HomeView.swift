//
//  HomeView.swift
//  PersonalData2
//
//  Created by bogdan on 14.04.2024.
//

import SwiftUI


extension SmokeStore {
    func cigarettesSmokedOn(date: Date) -> Int {
        let calendar = Calendar.current
        let smokesForDay = smokes.filter {
            calendar.isDate($0.start, inSameDayAs: date)
        }
        return smokesForDay.reduce(0) { $0 + $1.cigarettesSmoked }
    }
}


struct HomeView: View {
    
    @EnvironmentObject var userProfileManager: UserProfileManager
    @ObservedObject var smokeStore: SmokeStore
    @State private var showingAllSmokes = false

    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack(alignment: .leading) {
                  
                    Text("Hello \(userProfileManager.userProfile.name),")
                        .font(.largeTitle)
                        .padding()
                        .bold()
                    
                   
                    HStack{
                        Text("Goal Stack")
                            .font(.body)
                            .bold()
                            .font(.system(size: 10))
                        Spacer()
                        Text("Current Goal")
                            .font(.caption)
                            .foregroundColor(Color("Teams2"))
                            .font(.system(size: 10))
                        Text("\(userProfileManager.userProfile.newTarget) cigarettes/day")
                            .font(.caption)
                            .font(.system(size: 10))
                    }
                    .padding()
                    
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.white)
                        .shadow(radius: 10)
                        .frame(maxWidth: .infinity, minHeight: 120)
                        .overlay(
                            HStack {
                                
                                HStack(spacing: 10) {
                                    ForEach(Date().getWeekDates(), id: \.self) { date in
                                        VStack {
                                            Image(imageForDate(date))
                                                .frame(width: 30, height: 30)
                                            Spacer()
                                            Text(date.dayOfWeekAbbreviation)
                                                .font(.system(size: 10))
                                                .foregroundColor(colorForDate(date))
                                                .lineLimit(1)
                                        }
                                        .padding(1)
                                        .background(date.isToday ? Color("Teams").opacity(0.5) : Color.clear)
                                        .cornerRadius(5)
                                    }
                                }
                            }
                                .padding()
                        )
                        .padding()
                    

                    
                    Text("Your Progress So Far")
                        .font(.title2)
                        .padding()
                        .bold()
                    
                    HStack {
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 2)
                                .frame(height: 210)
                                .overlay(
                                    VStack {
                                        HStack{
                                            Text("Cigarettes Avoided")
                                                .font(.caption)
                                            Spacer()
                                            Image("ic-graphs-cig")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                        }
                                        
                                        Spacer()
                                        Text("\(smokeStore.totalCigarettesSmoked()) Cig")
                                            .bold()
                                    }
                                        .padding()
                                )
                        }
                        
                        VStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 2)
                                .frame(height: 100)
                                .overlay(
                                    VStack {
                                        HStack{
                                            Text("Money Saved")
                                                .font(.caption)
                                            Spacer()
                                            Image("ic-graphs-spending")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                        }
                                        
                                        Spacer()
                                        Text("\(smokeStore.totalCigarettesSmoked() * 3) DKK")
                                            .bold()
                                    }
                                        .padding()
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 2)
                                .frame(height: 100)
                                .overlay(
                                    VStack {
                                        HStack{
                                            Text("Time Saved")
                                                .font(.caption)
                                            Spacer()
                                            Image("ic-graphs-time")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                        }
                                        
                                        Spacer()
                                        Text(timeSavedAsString(smokeStore.totalCigarettesSmoked() * 5 * 60))
                                            .bold()
                                    }
                                        .padding()
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Last smokes stamps")
                        .font(.title2)
                        .padding()
                        .bold()
                    
                    TodaysSmokesView(smokeStore: smokeStore, showingAllSmokes: $showingAllSmokes)
                    
                }
            }
            .fullScreenCover(isPresented: $showingAllSmokes) {
                            SmokesView(smokeStore: smokeStore)
                        }
        }
    }
    func imageForDate(_ date: Date) -> String {
        let today = Calendar.current.startOfDay(for: Date())
        if date > today {
            return "ic-home-blank"
        } else {
            let count = smokeStore.cigarettesSmokedOn(date: date)
            return count > userProfileManager.userProfile.newTarget ? "ic-home-x" : "ic-home-ok"
        }
    }
    
    func colorForDate(_ date: Date) -> Color {
        let today = Calendar.current.startOfDay(for: Date())
        return date > today ? Color.gray : Color.primary
    }
    
    func timeSavedAsString(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return "\(hours) h and \(minutes) mins"
    }
}

extension Date {
    // Return the dates of the current week
    func getWeekDates() -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
   
    var dayOfWeekAbbreviation: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        switch weekday {
        case 1: return "Su"
        case 2: return "M"
        case 3: return "Tu"
        case 4: return "W"
        case 5: return "Th"
        case 6: return "F"
        case 7: return "Sa"
        default: return ""
        }
    }
}

struct TodaysSmokesView: View {
    @ObservedObject var smokeStore: SmokeStore
    @Binding var showingAllSmokes: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(smokeStore.smokes.filter {
                        
                        
                        Calendar.current.isDateInToday($0.start) }) { smoke in
                        SmokeViewToday(smoke: smoke)
                    }
                    
                    Text("See All Time Stamps")
                        .foregroundColor(Color("Teams"))
                        .padding()
                        .onTapGesture {
                            showingAllSmokes = true
                        }
                        .padding(.bottom, 50)
                }
            }

        }
    }
}


struct SmokeViewToday: View {

    var smoke: Smoke
    @State private var emotionIcon: String?


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
                                .frame(width: 30, height: 30)
                                .padding()
                        }


                    VStack(alignment: .leading) {
                        Text("\(smoke.end, formatter: dateFormatter)")
                            .font(.body)
                        Text("\(smoke.end, formatter: timeFormatter)")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                }
                    .onAppear {
                        emotionIcon = mapEmotiontoIcon(emotion: smoke.emotion ?? "")
                    }
                    .onChange(of: smoke.emotion) { newEmotion in
                        emotionIcon = mapEmotiontoIcon(emotion: newEmotion ?? "")
                    }
    }


}


