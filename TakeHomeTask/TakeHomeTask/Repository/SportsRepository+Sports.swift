//
//  SportsRepository+Sports.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import CoreData
import Combine

extension SportsRepository {
    internal func fetchAndCacheSports() async {
        await MainActor.run {
            self.isLoadingSports = true
            self.sportsError = nil
        }

        do {
            let networkSports = try await apiClient.fetchData(from: "/sports", type: [Sport].self)
            await cacheSports(networkSports)

            await MainActor.run {
                self.sports = networkSports
                self.isLoadingSports = false
                UserDefaults.standard.set(Date(), forKey: "lastDataRefresh")
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.sportsError = error
                self.isLoadingSports = false
            }
        } catch {
            await MainActor.run {
                self.sportsError = .unknown(error)
                self.isLoadingSports = false
            }
        }
    }

    internal func cacheSports(_ sports: [Sport]) async {
        let context = persistenceController.container.newBackgroundContext()

        await context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SportEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)

                sports.forEach { sport in
                    _ = SportEntity.from(sport: sport, in: context)
                }

                try context.save()
            } catch {
                print("Failed to cache sports: \(error)")
            }
        }
    }

    internal func getCachedSports() -> [Sport] {
        let context = persistenceController.container.viewContext
        let request = SportEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SportEntity.id,
          ascending: true)]

        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toSport() }
        } catch {
            print("Failed to fetch cached sports: \(error)")
            return []
        }
    }
}
