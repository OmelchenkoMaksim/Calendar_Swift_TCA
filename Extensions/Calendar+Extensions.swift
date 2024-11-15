// Extensions/Calendar+Extensions.swift
import Foundation

extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = [Date]()
        dates.append(dateInterval.start)
        
        self.enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: Calendar.MatchingPolicy.nextTime
        ) { (date: Date?, _, stop: inout Bool) in
            if let validDate: Date = date {
                if validDate < dateInterval.end {
                    dates.append(validDate)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}
