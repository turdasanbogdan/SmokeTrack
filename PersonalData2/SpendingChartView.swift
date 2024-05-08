//
//  SpendingChartView.swift
//  PersonalData2
//
//  Created by bogdan on 01.05.2024.
//
import SwiftUI
import Charts

struct SpendingChartView: View {
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
        case "Happy":
            return Color("Happy")
        case "Smiley":
            return Color("Smiley")
        case "Neutral":
            return Color("Neutral")
        case "Sad":
            return Color("Sad")
        case "Angry":
            return Color("Angry")
        default:
            return .gray // Fallback color
        }
    }

    var body: some View {
        
        let spendingData = smokeStore.aggregatedSpendingData(for: selectedTimeFrame, year: selectedYear, month: selectedMonth)

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
                ForEach(spendingData, id: \.0) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.0),
                        y: .value("Spending (DKK)", dataPoint.1)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color("SpendingChart"))
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom)
            }
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .leading)
            }
           
            
            
        }
    }
}
