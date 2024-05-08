//
//  Smoke.swift
//  PersonalData2
//
//  Created by bogdan on 14.04.2024.
//

import Foundation

struct Smoke: Identifiable, Hashable{
    
    
    
    let id = UUID()
    var start: Date
    var end: Date
    
    var emotion: String?
    var environment: String?
    var social: String?
    var cigarettesSmoked: Int = 1
    
    var duration: TimeInterval {
        end.timeIntervalSince(start)
    }
}

func generateMockData() -> [Smoke] {
    let today = Date()
    let calendar = Calendar.current

    
    let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today) ?? today
    let daysInLastThreeMonths = calendar.dateComponents([.day], from: threeMonthsAgo, to: today).day ?? 90

    return (0..<daysInLastThreeMonths).map { day in
        let startDate = calendar.date(byAdding: .day, value: -day, to: today)!
        let duration = TimeInterval(Int.random(in: 300...3600))
        let endDate = calendar.date(byAdding: .second, value: Int(duration), to: startDate)!

        let emotions = ["Happy", "Smiley", "Neutral", "Sad", "Angry"]
        let environments = ["party", "study", "work", "sports", "other"]
        let socials = ["myself", "friends", "family", "other"]

        return Smoke(start: startDate,
                     end: endDate,
                     emotion: emotions.randomElement(),
                     environment: environments.randomElement(),
                     social: socials.randomElement(),
                     cigarettesSmoked: Int.random(in: 1...3))
    }
}




class SmokeStore: ObservableObject {
    @Published var smokes: [Smoke] = generateMockData()

    init() {
        self.smokes = generateMockData()
    }

    func addSmoke(smoke: Smoke) {
        smokes.append(smoke)
    }

    func deleteSmoke(_ smoke: Smoke) {
        smokes.removeAll { $0.id == smoke.id }
    }
    
    func totalCigarettesSmoked() -> Int {
        smokes.reduce(0) { $0 + $1.cigarettesSmoked }
    }
    func moodCount(from smokes: [Smoke]) -> [String: Int] {
        let emotions = ["Happy", "Smiley", "Neutral", "Sad", "Angry"]

      
        var moodCounts = Dictionary(uniqueKeysWithValues: emotions.map { ($0, 0) })

       
        for smoke in smokes {
            if emotions.contains(smoke.emotion ?? "Neutral") {
                moodCounts[smoke.emotion ?? "Neutral", default: 0] += 1
            }
        }

        return moodCounts
    }
    
    func aggregatedSpendingData(for timeFrame: TimeFrame, year: Int, month: Int?) -> [(String, Double)] {
        let filteredSmokes = smokes.filter { smoke in
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: smoke.start)
            let yearMatches = dateComponents.year == year
            let monthMatches = month == nil || dateComponents.month == month
            return yearMatches && monthMatches
        }

        var groupedSpending: [String: Double] = [:]
        let dateFormatter = DateFormatter()
        for smoke in filteredSmokes {
            let dateKey: String
            switch timeFrame {
            case .daily:
                dateFormatter.dateFormat = "EEEE"
            case .weekly:
                dateFormatter.dateFormat = "W"
            case .monthly:
                dateFormatter.dateFormat = "MMMM"
            case .yearly:
                dateFormatter.dateFormat = "yyyy"
            }
            dateKey = dateFormatter.string(from: smoke.start)
            let spending = Double(smoke.cigarettesSmoked * 2)
            groupedSpending[dateKey, default: 0] += spending
        }
        
        return groupedSpending.map { (key, value) -> (String, Double) in
            (key, value)
        }.sorted { $0.0 < $1.0 }
    }
    func aggregatedSocialData(for timeframe: TimeFrame, year: Int, month: Int?) -> [(String, [String: Int])] {
        let calendar = Calendar.current
        
      
        let filteredSmokes = smokes.filter { smoke in
            let smokeYear = calendar.component(.year, from: smoke.start)
            let smokeMonth = calendar.component(.month, from: smoke.start)
            return smokeYear == year && (month == nil || smokeMonth == month)
        }

      
        let dateFormatter = DateFormatter()
        var groupedData = [String: [String: Int]]()

        for smoke in filteredSmokes {
            let key: String
            switch timeframe {
            case .daily:
                dateFormatter.dateFormat = "EEEE"
            case .weekly:
                dateFormatter.dateFormat = "W"
            case .monthly:
                dateFormatter.dateFormat = "MMMM"
            case .yearly:
                dateFormatter.dateFormat = "yyyy"
            }
            key = dateFormatter.string(from: smoke.start)

            if groupedData[key] == nil {
                groupedData[key] = [String: Int]()
            }
            let mood = smoke.social ?? "other"
            groupedData[key]![mood, default: 0] += 1
        }

       
        let moodData = groupedData.map { (key, moods) -> (String, [String: Int]) in
            return (key, moods)
        }

       
        
        print(moodData.sorted { $0.0 < $1.0 })
        return moodData.sorted { $0.0 < $1.0 }
    }
    
    func aggregatedActivityData(for timeframe: TimeFrame, year: Int, month: Int?) -> [(String, [String: Int])] {
        let calendar = Calendar.current
        
      
        let filteredSmokes = smokes.filter { smoke in
            let smokeYear = calendar.component(.year, from: smoke.start)
            let smokeMonth = calendar.component(.month, from: smoke.start)
            return smokeYear == year && (month == nil || smokeMonth == month)
        }

        
        let dateFormatter = DateFormatter()
        var groupedData = [String: [String: Int]]()

        for smoke in filteredSmokes {
            let key: String
            switch timeframe {
            case .daily:
                dateFormatter.dateFormat = "EEEE"
            case .weekly:
                dateFormatter.dateFormat = "W"
            case .monthly:
                dateFormatter.dateFormat = "MMMM"
            case .yearly:
                dateFormatter.dateFormat = "yyyy"
            }
            key = dateFormatter.string(from: smoke.start)

            if groupedData[key] == nil {
                groupedData[key] = [String: Int]()
            }
            let mood = smoke.environment ?? "other"
            groupedData[key]![mood, default: 0] += 1
        }

      
        let moodData = groupedData.map { (key, moods) -> (String, [String: Int]) in
            return (key, moods)
        }

      
        
        print(moodData.sorted { $0.0 < $1.0 })
        return moodData.sorted { $0.0 < $1.0 }
    }

    
    func aggregatedMoodData(for timeframe: TimeFrame, year: Int, month: Int?) -> [(String, [String: Int])] {
        let calendar = Calendar.current
        
       
        let filteredSmokes = smokes.filter { smoke in
            let smokeYear = calendar.component(.year, from: smoke.start)
            let smokeMonth = calendar.component(.month, from: smoke.start)
            return smokeYear == year && (month == nil || smokeMonth == month)
        }

       
        let dateFormatter = DateFormatter()
        var groupedData = [String: [String: Int]]()

        for smoke in filteredSmokes {
            let key: String
            switch timeframe {
            case .daily:
                dateFormatter.dateFormat = "EEEE"
            case .weekly:
                dateFormatter.dateFormat = "W"
            case .monthly:
                dateFormatter.dateFormat = "MMMM"
            case .yearly:
                dateFormatter.dateFormat = "yyyy"
            }
            key = dateFormatter.string(from: smoke.start)

            if groupedData[key] == nil {
                groupedData[key] = [String: Int]()
            }
            let mood = smoke.emotion ?? "Neutral"
            groupedData[key]![mood, default: 0] += 1
        }

       
        let moodData = groupedData.map { (key, moods) -> (String, [String: Int]) in
            return (key, moods)
        }

       
        
        print(moodData.sorted { $0.0 < $1.0 })
        return moodData.sorted { $0.0 < $1.0 }
    }
    
    func aggredatedDataTime(for timeFrame: TimeFrame, year: Int, month: Int) -> [(String, Int)] {
        let groupedSmokes: [String: [Smoke]]
        let formatter = DateFormatter()
        let currentCalendar = Calendar.current
        
        let filteredSmokes = smokes.filter { smoke in
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: smoke.start)
            let yearMatches = (year == nil || dateComponents.year == year)
            let monthMatches = (month == nil || month == -1 || dateComponents.month == month)
            return yearMatches && monthMatches
        }

                
        switch timeFrame {
        case .daily:
            formatter.dateFormat = "E"
            groupedSmokes = Dictionary(grouping: filteredSmokes, by: { formatter.string(from: $0.start) })
        case .weekly:
            formatter.dateFormat = "'W'w"
            groupedSmokes = Dictionary(grouping: filteredSmokes, by: { formatter.string(from: $0.start) })
        case .monthly:
            formatter.dateFormat = "MMMM"
            groupedSmokes = Dictionary(grouping: smokes, by: { formatter.string(from: $0.start) })
        case .yearly:
            formatter.dateFormat = "yyyy"
            groupedSmokes = Dictionary(grouping: smokes, by: { formatter.string(from: $0.start) })
        }
        
       
            
        let reducedData = groupedSmokes.map { key, value in
                  
        let totalMinutes = value.reduce(0.0) { total, smoke in
            total + smoke.duration
        }.rounded()
                return (key, Int(totalMinutes))
        }
                
            return reducedData.sorted { $0.0 < $1.0 }
            
    
        
    }



    func aggregatedData(for timeFrame: TimeFrame, year: Int, month: Int, dataType: DataType) -> [(String, Int)] {
        
        
        let groupedSmokes: [String: [Smoke]]
        let formatter = DateFormatter()
        let currentCalendar = Calendar.current
        
        let filteredSmokes = smokes.filter { smoke in
            let dateComponents = Calendar.current.dateComponents([.year, .month], from: smoke.start)
            let yearMatches = (year == nil || dateComponents.year == year)
            let monthMatches = (month == nil || month == -1 || dateComponents.month == month)
            return yearMatches && monthMatches
        }

                
        switch timeFrame {
        case .daily:
            formatter.dateFormat = "E"
            groupedSmokes = Dictionary(grouping: filteredSmokes, by: { formatter.string(from: $0.start) })
        case .weekly:
            formatter.dateFormat = "'W'w"
            groupedSmokes = Dictionary(grouping: filteredSmokes, by: { formatter.string(from: $0.start) })
        case .monthly:
            formatter.dateFormat = "MMMM"
            groupedSmokes = Dictionary(grouping: smokes, by: { formatter.string(from: $0.start) })
        case .yearly:
            formatter.dateFormat = "yyyy"
            groupedSmokes = Dictionary(grouping: smokes, by: { formatter.string(from: $0.start) })
        }
        
        switch dataType{
            
       
        case .smokedCigarettes:
            let reducedData = groupedSmokes.map { key, value in
                (key, value.reduce(0.0) { total, smoke in total + Double(smoke.cigarettesSmoked) })
            }
            let finalData = reducedData.map { (key, value) in
                (key, Int(value))
            }
            print(finalData.sorted { $0.0 < $1.0 })
            return finalData.sorted { $0.0 < $1.0 }
            
        case .smokingDuration:
            let reducedData = groupedSmokes.map { key, value in
                   
                    let totalMinutes = value.reduce(0.0) { total, smoke in
                        total + (smoke.duration / 216000)
                    }.rounded()
                    return (key, Int(totalMinutes)) 
                }
                return reducedData.sorted { $0.0 < $1.0 }
            
                        
        default:
            let reducedData = groupedSmokes.map { key, value in
                (key, value.reduce(0) { total, smoke in total + smoke.cigarettesSmoked })
            }
            return reducedData.sorted { $0.0 < $1.0 }
            
        }


    }
    
    
    
}
