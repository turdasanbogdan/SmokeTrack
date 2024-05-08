//
//  DashboardsViewTime.swift
//  PersonalData2
//
//  Created by bogdan on 01.05.2024.
//

import SwiftUI
import Charts

struct DashboardsViewTime: View {
    @ObservedObject var smokeStore: SmokeStore
    @State private var selectedTimeFrame: TimeFrame = .daily
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int?
    @State private var showDateSelector = false
    @State private var selectedDataType: DataType = .smokingDuration
    @State private var showPopover = false

    var years: [Int] {
        Array(1990...Calendar.current.component(.year, from: Date()))
    }
    let months: [String] = Calendar.current.monthSymbols

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
                ForEach(smokeStore.aggredatedDataTime(for: selectedTimeFrame, year: selectedYear, month: selectedMonth ?? -1), id: \.0) { data in
                    BarMark(
                        x: .value("Date", data.0),
                        y: .value("Minutes", Double(data.1) / 60.0)
                    )
                    .foregroundStyle(Color("graphs-time-select"))  // Using custom color from assets
                    .cornerRadius(5)
                }
            }
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
        }
    }
}


// Preview Section
//#Preview {
//    let smokeStore = SmokeStore()
//    DashboardsView(smokeStore: smokeStore)
//}
