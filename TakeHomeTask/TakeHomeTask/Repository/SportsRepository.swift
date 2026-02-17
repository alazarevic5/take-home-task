//
//  SportsRepository.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation
import CoreData
import Combine

class SportsRepository: ObservableObject {

    internal let apiClient = APIClient()
    internal let persistenceController: PersistenceController

    @Published var sports: [Sport] = []
    @Published var competitions: [Competition] = []
    @Published var matches: [Match] = []

    @Published var isLoadingSports = false
    @Published var isLoadingCompetitions = false
    @Published var isLoadingMatches = false

    @Published var sportsError: NetworkError?
    @Published var competitionsError: NetworkError?
    @Published var matchesError: NetworkError?

    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    func loadAllData() {
        loadCachedData()

        if sports.isEmpty || shouldRefreshData() {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await self.fetchAndCacheSports() }
                    group.addTask { await self.fetchAndCacheCompetitions() }
                    group.addTask { await self.fetchAndCacheMatches() }
                }
            }
        }
    }

    private func shouldRefreshData() -> Bool {
        // Refresh data every 5 minutes
        let lastRefresh = UserDefaults.standard.object(forKey: "lastDataRefresh") as? Date ?? Date.distantPast
        return Date().timeIntervalSince(lastRefresh) > 60
    }

    private func loadCachedData() {
        DispatchQueue.main.async {
            self.sports = self.getCachedSports()
            self.competitions = self.getCachedCompetitions()
            self.matches = self.getCachedMatches()
        }
    }

    func refreshAllData() {
        loadCachedData()
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchAndCacheSports() }
                group.addTask { await self.fetchAndCacheCompetitions() }
                group.addTask { await self.fetchAndCacheMatches() }
            }
        }
    }
}
