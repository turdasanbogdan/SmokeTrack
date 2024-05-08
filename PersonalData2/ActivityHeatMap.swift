import SwiftUI
import Charts

extension Date {
    var dateOnly: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
}

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
}

struct ActivityHeatMap: View {
    struct HeatmapEntry {
        let date: Date
        let active: Bool
        let isToday: Bool
        let isInFuture: Bool
        let gridRow: Int
        let gridCol: Int
        
        var color: Color {
            if active {
                return Color.green
            } else if isToday {
                return Color.blue
            } else if isInFuture {
                return Color.gray.opacity(0.25)
            } else {
                return Color.gray
            }
        }
    }

    var threeMonthEntries: [HeatmapEntry] {
        let now = Date.now
        let calendar = Calendar.current
        var results = [HeatmapEntry]()

        
        let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now)!

        
        let startOfThreeMonthsAgo = calendar.startOfMonth(for: threeMonthsAgo)

       
        let endOfCurrentMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: calendar.startOfMonth(for: now))!

        var currentDate = startOfThreeMonthsAgo
        while currentDate <= endOfCurrentMonth {
            let daysSinceStartOfThreeMonthsAgo = calendar.dateComponents([.day], from: startOfThreeMonthsAgo, to: currentDate).day!
            let weekNumber = daysSinceStartOfThreeMonthsAgo / 7
            let dayOfWeek = (calendar.component(.weekday, from: currentDate) - calendar.firstWeekday + 7) % 7

            let heatmapEntry = HeatmapEntry(
                date: currentDate,
                active: entry() != nil,
                isToday: currentDate.dateOnly == Date.now.dateOnly,
                isInFuture: currentDate > Date.now,
                gridRow: dayOfWeek,
                gridCol: weekNumber
            )
            results.append(heatmapEntry)
            
          
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return results
    }

    var body: some View {
        GeometryReader { geometry in
            let maxWeeks = threeMonthEntries.max(by: { $0.gridCol < $1.gridCol })?.gridCol ?? 1
            let dotWidth = geometry.size.width / CGFloat(maxWeeks + 1) - 1
            let dotHeight = geometry.size.height / 15 - 1
            
            HStack(spacing: 1) {
                ForEach(0...maxWeeks, id: \.self) { week in
                    VStack(spacing: 1) {
                        ForEach(0..<7, id: \.self) { day in
                            if let entry = threeMonthEntries.first(where: { $0.gridRow == day && $0.gridCol == week }) {
                                Rectangle()
                                    .fill(entry.color)
                                    .frame(width: dotWidth, height: dotHeight)
                                    .border(Color.white, width: 1) 
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: dotWidth, height: dotHeight)
                                    .border(Color.white, width: 1)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct ActivityHeatMap_Previews: PreviewProvider {
    static var previews: some View {
        ActivityHeatMap()
            .padding(16)
            .frame(width: 300, height: 300)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
