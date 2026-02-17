//
//  SportsRepository+CacheManagement.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import CoreData
import Combine

extension SportsRepository {
    internal func fetchAndCacheMatches() async {
        await MainActor.run {
            self.isLoadingMatches = true
            self.matchesError = nil
        }

        do {
            let networkMatches = try await apiClient.fetchData(from: "/matches", type: [Match].self)
            await cacheMatches(networkMatches)

            await MainActor.run {
                self.matches = networkMatches
                self.isLoadingMatches = false
                UserDefaults.standard.set(Date(), forKey: "lastDataRefresh")
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.matchesError = error
                self.isLoadingMatches = false
            }
        } catch {
            await MainActor.run {
                self.matchesError = .unknown(error)
                self.isLoadingMatches = false
            }
        }
    }

    /// Caches matches data to Core Data
    internal func cacheMatches(_ matches: [Match]) async {
        let context = persistenceController.container.newBackgroundContext()

        await context.perform {
            // Clear existing matches
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MatchEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)

                // Insert new matches
                matches.forEach { match in
                    _ = MatchEntity.from(match: match, in: context)
                }

                try context.save()
            } catch {
                print("Failed to cache matches: \(error)")
            }
        }
    }

    /// Retrieves cached matches from Core Data
    internal func getCachedMatches() -> [Match] {
        let context = persistenceController.container.viewContext
        let request = MatchEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MatchEntity.id,
          ascending: true)]

        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toMatch() }
        } catch {
            print("Failed to fetch cached matches: \(error)")
            return []
        }
    }
}
