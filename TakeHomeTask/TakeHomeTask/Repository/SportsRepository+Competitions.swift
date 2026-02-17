//
//  SportsRepository+Competitions.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import CoreData
import Combine

extension SportsRepository {
    internal func fetchAndCacheCompetitions() async {
        await MainActor.run {
            self.isLoadingCompetitions = true
            self.competitionsError = nil
        }

        do {
            let networkCompetitions = try await apiClient.fetchData(from: "/competitions", type: [Competition].self)
            await cacheCompetitions(networkCompetitions)

            await MainActor.run {
                self.competitions = networkCompetitions
                self.isLoadingCompetitions = false
                UserDefaults.standard.set(Date(), forKey: "lastDataRefresh")
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.competitionsError = error
                self.isLoadingCompetitions = false
            }
        } catch {
            await MainActor.run {
                self.competitionsError = .unknown(error)
                self.isLoadingCompetitions = false
            }
        }
    }

    internal func cacheCompetitions(_ competitions: [Competition]) async {
        let context = persistenceController.container.newBackgroundContext()

        await context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CompetitionEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)

                competitions.forEach { competition in
                    _ = CompetitionEntity.from(competition: competition, in: context)
                }

                try context.save()
            } catch {
                print("Failed to cache competitions: \(error)")
            }
        }
    }

    internal func getCachedCompetitions() -> [Competition] {
        let context = persistenceController.container.viewContext
        let request = CompetitionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath:
          \CompetitionEntity.id, ascending: true)]

        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toCompetition() }
        } catch {
            print("Failed to fetch cached competitions: \(error)")
            return []
        }
    }
}
