//
//  SportsViewModel+DataFiltering.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import Combine

extension SportsViewModel {
    internal func updateFilteredMatches(matches: [Match], sportId: Int?, timeTab: TimeFilter) {
        var filtered = matches

        // ...by selected sport
        if let sportId = sportId {
            filtered = repository.getMatches(forSportId: sportId)
        }

        // local filtering
        switch timeTab {
        case .today:
            filtered = filterMatchesForToday(filtered)
        case .tomorrow:
            filtered = filterMatchesForTomorrow(filtered)
        case .weekend:
            filtered = filterMatchesForWeekend(filtered)
        case .upcoming:
            filtered = repository.getUpcomingMatches()
            if let sportId = sportId {
                filtered = filtered.filter { $0.sportId == sportId }
            }
        }

        self.filteredMatches = filtered
    }

    internal func filterMatchesForToday(_ matches: [Match]) -> [Match] {
        let calendar = Calendar.current
        let today = Date()

        return matches.filter { match in
            if match.status == .live {
                return true
            }

            if let dateString = match.date,
               let matchDate = parseMatchDate(dateString) {
                return calendar.isDate(matchDate, inSameDayAs: today)
            }

            return false
        }
    }

    internal func filterMatchesForTomorrow(_ matches: [Match]) -> [Match] {
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) else {
            return []
        }

        return matches.filter { match in
            if let dateString = match.date,
               let matchDate = parseMatchDate(dateString) {
                return calendar.isDate(matchDate, inSameDayAs: tomorrow)
            }
            return false
        }
    }

    internal func filterMatchesForWeekend(_ matches: [Match]) -> [Match] {
        let calendar = Calendar.current

        return matches.filter { match in
            if let dateString = match.date,
               let matchDate = parseMatchDate(dateString) {
                let weekday = calendar.component(.weekday, from: matchDate)
                return weekday == 1 || weekday == 7 // Sunday = 1, Saturday = 7
            }
            return false
        }
    }

    internal func parseMatchDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
}
