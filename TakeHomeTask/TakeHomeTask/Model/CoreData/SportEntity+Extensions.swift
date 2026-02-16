//
//  SportEntity+Extensions.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import CoreData

extension SportEntity {

    func toSport() -> Sport {
        return Sport(id: Int(self.id), name: self.name ?? "", sportIconUrl: self.sportIconUrl)
    }

    static func from(sport: Sport, in context: NSManagedObjectContext) -> SportEntity {
        let entity = SportEntity(context: context)
        entity.id = Int64(sport.id)
        entity.name = sport.name
        entity.sportIconUrl = sport.sportIconUrl
        entity.lastUpdated = Date()
        return entity
    }
}
