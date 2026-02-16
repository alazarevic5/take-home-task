//
//  SportsViewModel+PublicActions.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

extension SportsViewModel {
    func selectSport(withId sportId: Int) {
        self.selectedSportId = sportId
    }

    func selectTimeTab(_ tab: TimeFilter) {
        self.selectedTimeTab = tab
    }

    func getLiveMatches() -> [Match] {
        let liveMatches = repository.getLiveMatches()
        guard let selectedSportId = selectedSportId else {
            return liveMatches
        }
        return liveMatches.filter { $0.sportId == selectedSportId }
    }

    func getUpcomingMatches() -> [Match] {
        let upcomingMatches = repository.getUpcomingMatches()
        guard let selectedSportId = selectedSportId else {
            return upcomingMatches
        }
        return upcomingMatches.filter { $0.sportId == selectedSportId }
    }

    func getSportName(for id: Int) -> String {
        return availableSports.first { $0.id == id }?.name ?? "Unknown Sport"
    }

    func getCompetitionName(for id: Int) -> String {
        return repository.competitions.first { $0.id == id }?.name ?? "Unknown Competition"
    }

    func getCompetition(for id: Int) -> Competition? {
        return repository.competitions.first { $0.id == id }
    }

    func refreshData() {
        repository.refreshAllData()
    }

    var hasOfflineData: Bool {
        return !availableSports.isEmpty || !repository.matches.isEmpty
    }

    var statusMessage: String {
        if hasError {
            return errorMessage
        }

        if isLoading && !hasOfflineData {
            return "Učitavanje podataka..."
        }

        if !hasOfflineData {
            return "Nema dostupnih podataka"
        }

        if filteredMatches.isEmpty {
            return "Nema mečeva za izabrani filter"
        }

        return ""
    }
}
