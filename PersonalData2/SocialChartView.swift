//
//  SocialChartView.swift
//  PersonalData2
//
//  Created by bogdan on 01.05.2024.
//
//let socials = ["myself", "friends", "family", "other"]

//
//  ActivityChartView.swift
//  PersonalData2
//
//  Created by bogdan on 01.05.2024.
//


import SwiftUI
import Charts

enum socialType: String, CaseIterable {
    case myself = "myself"
    case friends = "friends"
    case family = "family"
    case other = "other"
    var color: Color {
        switch self {
        case .myself:
            return Color("myself")
        case .friends:
            return Color("friends")
        case .family:
            return Color("family")
        case .other:
            return Color("other_social")
        default:
            return .gray
            
        }
    }
}

struct SocialChartView: View {
    
    @ObservedObject var smokeStore: SmokeStore
    @State private var selectedTimeFrame: TimeFrame = .daily
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int?
    @State private var showDateSelector = false
    @State private var selectedDataType: DataType = .mood
    @State private var showPopover = false
    

    var years: [Int] {
        Array(1990...Calendar.current.component(.year, from: Date()))
    }
    let months: [String] = Calendar.current.monthSymbols
    
    
    func color(for mood: String) -> Color {
        switch mood {
        case "myself":
            return Color("myself")
        case "friends":
            return Color("friends")
        case "family":
            return Color("family")
        case "other":
            return Color("other_social")
        default:
            return .gray // Fallback color
        }
    }

    var body: some View {
        VStack{
            HStack{
                Picker("Select Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                        Text(timeFrame.rawValue).tag(timeFrame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: {
                    showPopover = true
                }) {
                    Image("ic-calendar-button")
                        .font(.title)
                        
                }
                .popover(isPresented: $showPopover, attachmentAnchor: .point(.topLeading)) {
                    YearMonthSelector(selectedYear: $selectedYear, selectedMonth: $selectedMonth, years: years)
                        .frame(width: 300, height: 400)  // Adjust the frame as needed
                        .padding()
                        .presentationCompactAdaptation(.popover)
                }
            }
            .sheet(isPresented: $showDateSelector) {
                VStack {
                    Text("Select Year and Month")
                        .font(.headline)
                        .padding()

                    HStack {
                        Button(action: {
                            if selectedYear > years.first! { // Prevent decrementing below the minimum year
                                selectedYear -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        Text("\(selectedYear)")
                            .font(.headline)
                            .frame(minWidth: 80)
                        Button(action: {
                            if selectedYear < years.last! { // Prevent incrementing above the current year
                                selectedYear += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding()

                    VStack(alignment: .leading) {
                        ForEach(1...12, id: \.self) { month in
                            Button(action: {
                                selectedMonth = month
                                showDateSelector = false
                            }) {
                                Text(months[month - 1])
                                    .font(.body)
                                    .foregroundColor(selectedMonth == month ? .white : .black)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(selectedMonth == month ? Color.blue : Color.clear)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .padding()
                    
                    Button("Done") {
                        showDateSelector = false
                    }
                    .padding()
                }
            }
            
            Chart {
                ForEach(smokeStore.aggregatedSocialData(for: selectedTimeFrame, year: selectedYear, month: selectedMonth), id: \.0) { (date, moods) in
                    ForEach(moods.keys.sorted(), id: \.self) { mood in
                        BarMark(
                            x: .value("Date", date),
                            y: .value("Count", moods[mood] ?? 0)
//                            stackId: mood
                        )
                        .foregroundStyle(color(for: mood))
                    }
                }
            }
            .chartLegend(position: .top, alignment: .center, spacing: 24, content: {
                HStack(spacing: 6) {
                    ForEach(socialType.allCases, id: \.self) { type in
                        Circle()
                            .fill(type.color)
                            .frame(width: 8, height: 8)
                        Text(type.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(type.color)
                    }
                }
            })
            
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }

            .padding()
            .chartLegend(.hidden)
            
            HStack(spacing: 6) {
                ForEach(socialType.allCases, id: \.self) { type in
                    Circle()
                        .fill(type.color)
                        .frame(width: 8, height: 8)
                    Text(type.rawValue)
                        .font(.system(size: 11, weight: .medium))
//                        .foregroundColor(type.color)
                }
            }
            .padding(.top, 10)
           
            
            
        }
    }
}


// Preview Section
//#Preview {
//    let smokeStore = SmokeStore()
//    DashboardsView(smokeStore: smokeStore)
//}


