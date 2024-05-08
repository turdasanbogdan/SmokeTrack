import SwiftUI

struct YearMonthSelector: View {
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int?
    let years: [Int]
    let months: [String] = Calendar.current.standaloneMonthSymbols
   

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            HStack {
                Button(action: decrementYear) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Teams"))
                }
                .disabled(selectedYear == years.first)
                
                var str2 = String(selectedYear)
               
                Text(str2)
                    .font(.headline)

                Button(action: incrementYear) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("Teams"))
                }
                .disabled(selectedYear == years.last)
            }

            Divider()

            
            let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(months.indices, id: \.self) { index in
                    Button(action: { toggleMonthSelection(index: index + 1) }) {
                        Text(months[index])
                            .foregroundColor(selectedMonth == index + 1 ? .white : .primary)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(selectedMonth == index + 1 ? Color("Teams") : Color.clear)
                            .cornerRadius(5)
                    }
                }
            }
        }
        .padding()
    }

    private func decrementYear() {
        if let currentIndex = years.firstIndex(of: selectedYear), currentIndex > 0 {
            selectedYear = years[currentIndex - 1]
        }
    }

    private func incrementYear() {
        if let currentIndex = years.firstIndex(of: selectedYear), currentIndex < years.count - 1 {
            selectedYear = years[currentIndex + 1]
        }
    }

    private func toggleMonthSelection(index: Int) {
        if selectedMonth == index {
            selectedMonth = nil 
        } else {
            selectedMonth = index
        }
    }
}
