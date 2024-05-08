//
//  DataOverview2.swift
//  PersonalData2
//
//  Created by bogdan on 30.04.2024.
//

import SwiftUI

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}

struct SpendingStats {
    var averageSpending: Double
    var highestSpendingMonth: (month: String, amount: Double)
    var lowestSpendingMonth: (month: String, amount: Double)
}

struct ActivityStats {
    var mostActivity: String
    var mostCount: Int
    var leastActivity: String
    var leastCount: Int
}

struct SocialStats {
    var bestSocial: String
    var bestCount: Int
    var leastSocial: String
    var leastCount: Int
}

struct SmokingStats {
    var averagePerDay: Double
    var dayWithMostCigarettes: (day: String, count: Int)
    var timeIntervalWithMost: (interval: String, count: Int)
    var mostFrequentSmokingDay: String
}


struct SmokingDurationStats {
    let averageDuration: Double
}

func calculateSmokingStats(smokes: [Smoke]) -> SmokingStats {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    var dailyCounts = [String: Int]()
    var hourlyCounts = [Int: Int]()
    var weekdayCounts = [String: Int]()
    for smoke in smokes {
        let day = dateFormatter.string(from: smoke.start)
        dailyCounts[day, default: 0] += smoke.cigarettesSmoked

        let hour = calendar.component(.hour, from: smoke.start)
        let hourBlock = (hour / 2) * 2
        hourlyCounts[hourBlock, default: 0] += smoke.cigarettesSmoked

        let weekdayIndex = calendar.component(.weekday, from: smoke.start)
        let weekday = dateFormatter.weekdaySymbols[weekdayIndex - 1]
        weekdayCounts[weekday, default: 0] += smoke.cigarettesSmoked
    }

    let totalCigarettes = dailyCounts.values.reduce(0, +)
    let numDays = dailyCounts.count
    let averagePerDay = (Double(totalCigarettes) / Double(numDays)).rounded()

    let dayWithMost = dailyCounts.max { a, b in a.value < b.value }!
    let intervalWithMost = hourlyCounts.max { a, b in a.value < b.value }!
    let formattedInterval = "\(intervalWithMost.key):00-\(intervalWithMost.key + 2):00"
    
    let mostFrequentSmokingDay = weekdayCounts.max { a, b in a.value < b.value }!

    return SmokingStats(
        averagePerDay: averagePerDay,
        dayWithMostCigarettes: (dayWithMost.key, dayWithMost.value),
        timeIntervalWithMost: (formattedInterval, intervalWithMost.value),
        mostFrequentSmokingDay: mostFrequentSmokingDay.key
    )
}

func calculateSocialStats(smokes: [Smoke]) -> SocialStats {
    var socialCounts = [String: Int]()

    for smoke in smokes {
        let social = smoke.social ?? "Alone"
        socialCounts[social, default: 0] += 1
    }

    if let bestSocial = socialCounts.max(by: { $0.value < $1.value }),
       let leastSocial = socialCounts.min(by: { $0.value < $1.value }) {
        return SocialStats(
            bestSocial: bestSocial.key.capitalizingFirstLetter(),
            bestCount: bestSocial.value,
            leastSocial: leastSocial.key.capitalizingFirstLetter(),
            leastCount: leastSocial.value
        )
    }

    return SocialStats(bestSocial: "None", bestCount: 0, leastSocial: "None", leastCount: 0)
}

func calculateSpendingStats(smokes: [Smoke]) -> SpendingStats {
    let calendar = Calendar.current
    let months = calendar.monthSymbols

   
    var monthlySpending: [Int: Double] = [:]

    for smoke in smokes {
        let month = calendar.component(.month, from: smoke.start)
        let spending = Double(smoke.cigarettesSmoked * 2)  // Each cigarette costs 2 DKK
        monthlySpending[month, default: 0] += spending
    }


    let totalSpending = monthlySpending.values.reduce(0, +)
    let averageSpending = totalSpending / Double(monthlySpending.count)
    let sortedSpending = monthlySpending.sorted { $0.value < $1.value }
    let highest = sortedSpending.last!
    let lowest = sortedSpending.first!

    return SpendingStats(
        averageSpending: averageSpending,
        highestSpendingMonth: (months[highest.key - 1], highest.value),
        lowestSpendingMonth: (months[lowest.key - 1], lowest.value)
    )
}

func calculateEmotionStats(smokes: [Smoke]) -> (mostEmotion: String, mostPercentage: Double, leastEmotion: String, leastPercentage: Double) {
    var emotionCounts = [String: Int]()

    for smoke in smokes {
        let emotion = smoke.emotion ?? "Neutral"
        emotionCounts[emotion, default: 0] += 1
    }

    if let mostCommon = emotionCounts.max(by: { $0.value < $1.value }),
       let leastCommon = emotionCounts.min(by: { $0.value < $1.value }),
       let total = emotionCounts.values.reduce(0, +) as Int?,
       total > 0 {
        
        let mostPercentage = (Double(mostCommon.value) / Double(total)) * 100
        let leastPercentage = (Double(leastCommon.value) / Double(total)) * 100
        
        return (mostCommon.key, mostPercentage, leastCommon.key, leastPercentage)
    }

    return ("None", 0.0, "None", 0.0)
}

func calculateActivityStats(smokes: [Smoke]) -> ActivityStats {
    var activityCounts = [String: Int]()

    for smoke in smokes {
        let activity = smoke.environment ?? "Unknown"
        activityCounts[activity, default: 0] += 1
    }

    if let mostCommon = activityCounts.max(by: { $0.value < $1.value }),
       let leastCommon = activityCounts.min(by: { $0.value < $1.value }) {
        return ActivityStats(
            mostActivity: mostCommon.key,
            mostCount: mostCommon.value,
            leastActivity: leastCommon.key,
            leastCount: leastCommon.value
        )
    }

    return ActivityStats(mostActivity: "None", mostCount: 0, leastActivity: "None", leastCount: 0)
}

func calculateAverageSmokingDuration(smokes: [Smoke]) -> Double {
    let totalDuration = smokes.reduce(0.0) { (result, smoke) -> TimeInterval in
        return result + smoke.duration
    }
    return smokes.isEmpty ? 0 : totalDuration / Double(smokes.count)
}

func formatDuration(seconds: TimeInterval) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return "\(minutes) minutes and \(remainingSeconds) seconds"
}
struct DataOverview2: View {
    
    @ObservedObject var smokeStore: SmokeStore
    
    
    func imageNameForEmotion(_ emotion: String) -> String {
        switch emotion {
        case "Happy":
            return "ic-emoji-happy"
        case "Sad":
            return "ic-emoji-sad"
        case "Angry":
            return "ic-emoji-angry"
        case "Neutral":
            return "ic-emoji-neutral"
        case "Smiley":
            return "ic-emoji-smile"
        default:
            return "ic-emoji-neutral"
        }
    }
    
    var body: some View {
        
        let stats = calculateEmotionStats(smokes: smokeStore.smokes)
        let statsSpending = calculateSpendingStats(smokes: smokeStore.smokes)
        let statsActivity = calculateActivityStats(smokes: smokeStore.smokes)
        let socialStats = calculateSocialStats(smokes: smokeStore.smokes)
        let statsSmoke = calculateSmokingStats(smokes: smokeStore.smokes)
        let averageDuration = calculateAverageSmokingDuration(smokes: smokeStore.smokes)
        let durationStats = SmokingDurationStats(averageDuration: averageDuration)
        
       
            
            ScrollView {
                
                Text("Data Overview")
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading, spacing: 20) {
                

                
                Image("ic-graphs-heatmap")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 220)
                    .clipped()
                
                Spacer()
                
                Text("Understand your patterns")
                    .font(.title2)
                    .bold()
                
                
                NavigationLink(destination: SmokingStatsView(smokeStore: smokeStore, stats: statsSmoke)) {
                    HStack {
                        Image("ic-graphs-cig")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Smoke Count")
                                .bold()
                            
                            Text("\(statsSmoke.averagePerDay)" + " Cig")
                                .foregroundColor(Color.purple)
                                .font(.subheadline)
                            + Text(" as average day")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image("ic-graphs-histogram")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: SpendingView(smokeStore: smokeStore, stats: statsSpending)) {
                    HStack {
                        Image("ic-graphs-spending")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spences")
                                .bold()
                            Text("\(statsSpending.averageSpending)" + " DKK")
                                .foregroundColor(Color.purple)
                                .font(.subheadline)
                            + Text(" monthly spences")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image("ic-graphs-line")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: ActivityView(smokeStore: smokeStore, stats: statsActivity)) {
                    HStack {
                        Image("ic-profile-activity")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Activity")
                                .bold()
                            
                            Text("\(statsActivity.mostActivity.capitalizingFirstLetter())")
                                .foregroundColor(Color.purple)
                                .font(.subheadline)
                            + Text(" as main activity")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image("ic-graphs-bar")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: MoodView(smokeStore: smokeStore, stats: stats)) {
                    HStack {

                        
                        ZStack {
                            Image("ic-insights-mood")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            
                            Image(imageNameForEmotion(stats.mostEmotion))
                                .resizable()
                                .frame(width: 40, height: 40)
                            
                        } .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mood")
                                .bold()
                            Text("\(stats.mostEmotion)")
                                .foregroundColor(Color.purple)
                                .font(.subheadline)
                            + Text(" as most selected mood")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image("ic-graphs-bar")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: SocialActivityView(smokeStore: smokeStore, socialStats: socialStats)) {
                    HStack {
                        Image("ic-graphs-social")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Social")
                                .bold()
                            Text("Mostly with ")
                                .font(.subheadline)
                            + Text( "\(socialStats.bestSocial)")
                                .foregroundColor(Color.purple)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image("ic-graphs-bar")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(5)
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: SmokingDurationView(smokeStore: smokeStore, stats: durationStats)) {
                    HStack {
                        Image("ic-graphs-time")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Session Time")
                                .bold()
                            Text("Normally ")
                            + Text(formatDuration(seconds: durationStats.averageDuration))
                                .foregroundColor(Color.purple)
                                .font(.subheadline)
                            + Text(" per smoke")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image("ic-graphs-line")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing, 16)
                    }
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(5)
                    .padding(.bottom, 30)
                   
                }
                .buttonStyle(PlainButtonStyle())
                
                    
                    
                    
                    Text("Other interesting patterns")
                        .font(.title2)
                        .bold()
                    
                    NavigationLink(destination: MapZoomView()) {
                        HStack {
                            Image("ic-maps")
                                .resizable()
                                .frame(width: .infinity, height: 100)
                                
                        }
                       
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(5)
                        .padding(.bottom, 50)
                       
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                
            }
            .padding()
        }
    }
}

struct HistogramView: View {
    var body: some View {
        Text("Histogram View")
    }
}

struct SmokingDurationView: View {
    @ObservedObject var smokeStore: SmokeStore
    var stats: SmokingDurationStats
    
    var body: some View {
        VStack(alignment: .leading) {
            DashboardsViewTime(smokeStore: smokeStore)
                .frame(height: 350)
                .padding(.top, 0)
            Spacer()
            Text("Insights")
                .font(.title)
                .bold()
                .padding()

            insightsView(
                title: "Average Smoking Time",
                value: formatDuration(seconds: stats.averageDuration),
                imageName: "ic-insights-duration"
            )
            
            Spacer()
        }
        .navigationTitle("Session time in min")
    }

    @ViewBuilder
    private func insightsView(title: String, value: String, imageName: String, color: Color = .black) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .bold()
                Text(value)
                    .font(.footnote)
                    .foregroundColor(.purple)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .frame(height: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


struct SmokingStatsView: View {
    @ObservedObject var smokeStore: SmokeStore
    let stats: SmokingStats
    
    var body: some View {
       
        
        VStack(alignment: .leading) {
            
            DashboardsView(smokeStore: smokeStore)
                .frame(height: 350)
                .padding(.top, 0)
            
            Spacer()
            
            Text("Insights")
                .font(.title)
                .bold()
                .padding()

            insightsView(
                title: "Average Cigarettes per Day",
                purpleVal:  "\(String(format: "%.2f", stats.averagePerDay))",
                value: "cigarettes",
                imageName: "ic-insights-count"
            )
            insightsView(
                title: "Most Cigarettes in a Day",
                purpleVal: "\(String(stats.dayWithMostCigarettes.day))",
                value: "with \(stats.dayWithMostCigarettes.count) cigarettes",
                imageName: "ic-insights-count"
            )
            insightsView(
                title: "Most Cigarettes in an Interval",
                purpleVal: "\(String(stats.timeIntervalWithMost.interval))",
                value: "with \(stats.timeIntervalWithMost.count) cigarettes",
                imageName: "ic-insights-count"
            )
            
            Spacer()
        }
        .navigationTitle("Smoke Count")
    }

    @ViewBuilder
    private func insightsView(title: String, purpleVal:String,  value: String, imageName: String) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .bold()
                
                HStack{
                    Text(purpleVal)
                        .foregroundColor(.purple)
                        .font(.footnote)
                    Text(value)
                        .font(.footnote)
                }


            }
            Spacer()
        }
        .frame(height: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SpendingView: View {
    @ObservedObject var smokeStore: SmokeStore
    let stats: SpendingStats
    
    var body: some View {
        VStack(alignment: .leading) {
            SpendingChartView(smokeStore: smokeStore)
                .frame(height: 350)
                .padding(.top, 0)
                        
            Spacer()
            
            Text("Insights")
                .font(.title)
                .bold()
                .padding()

            insightsView(
                title: "Average Spent",
                purpleVal: String(format: "%.2f", stats.averageSpending),
                value: "as average expenses",
                imageName: "ic-insights-spences"
            )
            insightsView(
                title: "Highest Spend",
                purpleVal:String(format: "%@ (%.2f)", stats.highestSpendingMonth.month, stats.highestSpendingMonth.amount),
                value: "as the month with most expenses",
                imageName: "ic-insights-spences"
                
            )
            insightsView(
                title: "Lowest Spend",
                purpleVal: String(format: "%@ (%.2f)", stats.lowestSpendingMonth.month, stats.lowestSpendingMonth.amount),
                value: "as the month with least expenses",
                imageName: "ic-insights-spences"
            )
            
            Spacer()
        }
        .navigationTitle("Expenses in DKK")
    }

    @ViewBuilder
    private func insightsView(title: String, purpleVal: String, value: String, imageName: String, color: Color = .black) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .bold()
                
                HStack{
                    Text(purpleVal)
                        .font(.footnote)
                        .foregroundColor(.purple)
                    Text(value)
                        .font(.footnote)
                        .lineLimit(1)
                }

            }
            
            Spacer()
        }
        .frame(height: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


struct ActivityView: View {
    @ObservedObject var smokeStore: SmokeStore
    let stats: ActivityStats
    
    var body: some View {
       
        
        VStack(alignment: .leading) {
            
            ActivityChartView(smokeStore: smokeStore)
                .frame(height: 350)
                .padding(.top, 0)
            
            Spacer()
            
            Text("Insights")
                .font(.title)
                .bold()
                .padding()

            insightsView(
                title: "Most Frequent Activity",
                purpleVal: "\(stats.mostActivity)",
                value: "with \(stats.mostCount) occurrences",
                imageName: "ic-insights-activity"
            )
            insightsView(
                title: "Least Frequent Activity",
                purpleVal:"\(stats.leastActivity)",
                value: "with \(stats.leastCount) occurrences",
                imageName: "ic-insights-activity"
            )
            
            Spacer()
        }
        .navigationTitle("Activity")
    }
    
    @ViewBuilder
    private func insightsView(title: String, purpleVal: String,  value: String, imageName: String) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .bold()
                
                HStack{
                    Text(purpleVal)
                        .font(.footnote)
                        .foregroundColor(.purple)
                    Text(value)
                        .font(.footnote)
                }
            
            }
            Spacer()
        }
        .frame(height: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct MoodView: View {
    @ObservedObject var smokeStore: SmokeStore
    let stats: (mostEmotion: String, mostPercentage: Double, leastEmotion: String, leastPercentage: Double)
    
    var body: some View {
        let stats = calculateEmotionStats(smokes: smokeStore.smokes)
            
            VStack(alignment: .leading) {
                
                MoodChartView(smokeStore: smokeStore)
                    .frame(height: 350)
                
                Spacer()
                
                Text("Insights")
                    .font(.title)
                    .bold()
                    .padding()
                
                HStack {
                    Image("ic-insights-mood")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading, 16)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Most Frequent Emotion")
                            .bold()
                        HStack(spacing: 0) {
                            Text("\(stats.mostEmotion)")
                                .font(.footnote)
                                .foregroundColor(.purple)
                            Text(" as most chosen emotion with ")
                                .font(.footnote)

                            Text("\(String(format: "%.2f", stats.mostPercentage))%")
                                .font(.footnote)
                        }
                       
                    }
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack {
                    Image("ic-insights-mood")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.leading, 16)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Least Frequent Emotion")
                            .bold()
                        HStack(spacing: 0) {
                            Text("\(stats.leastEmotion)")
                                .font(.footnote) 
                        
                                .foregroundColor(.purple)

                            Text(" as least chosen emotion with ")
                                .font(.footnote)

                            Text("\(String(format: "%.2f", stats.leastPercentage))%")
                                .font(.footnote)
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .navigationTitle("Mood")
        }
}

struct SocialActivityView: View {
    @ObservedObject var smokeStore: SmokeStore
    let socialStats: SocialStats
    
    var body: some View {
        
        VStack(alignment: .leading) {
            SocialChartView(smokeStore: smokeStore)
                .frame(height: 350)
                .padding(.top, 0)
            
            Spacer()
            Text("Insights")
                .font(.title)
                .bold()
                .padding()

            insightsView(
                title: "Your best companion",
                purpleVal: "\(socialStats.bestSocial)",
                value: "with \(socialStats.bestCount) occurrences",
                imageName: "ic-insights-social"
            )
            insightsView(
                title: "Smoking less when with",
                purpleVal:"\(socialStats.leastSocial)",
                value: "with \(socialStats.leastCount) occurrences",
                imageName: "ic-insights-social"
            )
            
            Spacer()
        }
        .navigationTitle("Social")
    }
    
    @ViewBuilder
    private func insightsView(title: String, purpleVal:String, value: String, imageName: String) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 16)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .bold()
                
                HStack{
                    Text(purpleVal)
                        .font(.footnote)
                        .foregroundColor(.purple)
                    Text(value)
                        .font(.footnote)
                }
             
                    
            }
            Spacer()
        }
        .frame(height: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DataOverview_Previews: PreviewProvider {
    static let smokeStore = SmokeStore()

    static var previews: some View {
        NavigationView {
            DataOverview2(smokeStore: smokeStore)
        }
    }
}

