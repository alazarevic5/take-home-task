//
//  CompetitionEntity+Extensions.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import CoreData

extension CompetitionEntity {

    func toCompetition() -> Competition {
        return Competition(
            id: self.id != 0 ? Int(self.id) : nil,
            sportId: self.sportId != 0 ? Int(self.sportId) : nil,
            name: self.name,
            competitionIconUrl: self.competitionIconUrl
        )
    }

    static func from(competition: Competition, in context: NSManagedObjectContext) -> CompetitionEntity {
        let entity = CompetitionEntity(context: context)
        entity.id = Int64(competition.id ?? 0)
        entity.sportId = Int64(competition.sportId ?? 0)
        entity.name = competition.name
        entity.competitionIconUrl = competition.competitionIconUrl
        entity.lastUpdated = Date()
        return entity
    }
}
