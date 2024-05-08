//
//  HeatMapView.swift
//  PersonalData2
//
//  Created by bogdan on 30.04.2024.
//

import SwiftUI
import Charts

struct Point: Hashable, Identifiable {
    let id = UUID()
    let x: Int
    let y: Int
    let val: Float
}

struct Grid {
    
    let rows: Int
    let columns: Int
    var points = [Point]()
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        generateData()
    }
    
    mutating func generateData() {
        for i in 0..<rows {
            for j in 0..<columns {
                let v = Float.random(in: 0...1)
                let point = Point(x: j, y: i, val: v)
                points.append(point)
            }
        }
    }
}

struct HeatMapView: View {
    // Your data points
    @State private var grid = Grid(rows: 10, columns: 10)
    @ObservedObject var smokeStore: SmokeStore
    
    
    let monthLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let dayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        let groupedSmokes = groupSmokesByMonthAndDay(smokes: smokeStore.smokes)
        let points = calculatePoints(groupedSmokes: groupedSmokes)
        
        Chart(points) { point in
            RectangleMark(
                xStart: .value("xStart", Double(point.x)),
                xEnd: .value("xEnd", Double(point.x + 1)),
                yStart: .value("yStart", Double(point.y)),
                yEnd: .value("yEnd", Double(point.y + 1))
            )
            .foregroundStyle(by: .value("Weight", point.val))
           
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartForegroundStyleScale(range: Gradient(colors: [.yellow, .red]))
        .padding()
        .frame(minWidth: 400, minHeight: 400)
    }
    
    private func groupSmokesByMonthAndDay(smokes: [Smoke]) -> [Int: [Int: Int]] {
        var groupedSmokes = [Int: [Int: Int]]()
        
        for smoke in smokes {
            let month = Calendar.current.component(.month, from: smoke.start)
            let dayOfWeek = Calendar.current.component(.weekday, from: smoke.start)
            
            if groupedSmokes[month] == nil {
                groupedSmokes[month] = [Int: Int]()
            }
            
            if let totalConsumption = groupedSmokes[month]?[dayOfWeek] {
                groupedSmokes[month]?[dayOfWeek] = totalConsumption + smoke.cigarettesSmoked
            } else {
                groupedSmokes[month]?[dayOfWeek] = smoke.cigarettesSmoked
            }
        }
        
        return groupedSmokes
    }
    
    private func calculatePoints(groupedSmokes: [Int: [Int: Int]]) -> [Point] {
        var points = [Point]()
        
        for (month, smokesByDay) in groupedSmokes {
            for (dayOfWeek, totalConsumption) in smokesByDay {
                let x = dayOfWeek - 1
                let y = month - 1
                let value = min(Float(totalConsumption), 10)
                points.append(Point(x: y, y: x, val: value))
            }
        }
        
        return points
    }
}

struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        let smokeStore = SmokeStore()
        smokeStore.smokes = generateMockData()
        return HeatMapView(smokeStore: smokeStore)
    }
}
