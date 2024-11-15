// Views/CalendarGridView.swift
import SwiftUI
import ComposableArchitecture
import Foundation

struct CalendarGridView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        WithViewStore(
            self.store,
            observe: { state in state }
        ) { viewStore in
            VStack {
                // Заголовок с днями недели
                HStack {
                    ForEach(
                        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
                        id: \String.self
                    ) { day in
                        Text(day)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(Font.caption)
                    }
                }
                
                // Календарная сетка
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(GridItem.Size.flexible()),
                        count: 7
                    )
                ) {
                    ForEach(
                        self.daysInMonth(for: viewStore.selectedDate),
                        id: \Date.self
                    ) { date in
                        DateCell(
                            date: date,
                            isSelected: Calendar.current.isDate(
                                date,
                                inSameDayAs: viewStore.selectedDate
                            )
                        )
                        .onTapGesture {
                            viewStore.send(CalendarFeature.Action.selectDate(date))
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
    }
    
    private func daysInMonth(for date: Date) -> [Date] {
        let calendar: Calendar = Calendar.current
        guard let monthInterval: DateInterval = calendar.dateInterval(of: Calendar.Component.month, for: date),
              let monthFirstWeek: DateInterval = calendar.dateInterval(of: Calendar.Component.weekOfMonth, for: monthInterval.start),
              let monthLastWeek: DateInterval = calendar.dateInterval(of: Calendar.Component.weekOfMonth, for: monthInterval.end)
        else {
            return []
        }
        
        let dateInterval: DateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDates(
            for: dateInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}

// DateCell view
private struct DateCell: View {
    let date: Date
    let isSelected: Bool
    
    var body: some View {
        Text("\(Calendar.current.component(Calendar.Component.day, from: self.date))")
            .frame(height: 40, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(self.isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .clipShape(Circle())
            .foregroundColor(self.isSelected ? Color.white : Color.primary)
            .overlay(
                Circle()
                    .stroke(
                        self.isSelected ? Color.blue : Color.clear,
                        lineWidth: 1
                    )
            )
            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
}
