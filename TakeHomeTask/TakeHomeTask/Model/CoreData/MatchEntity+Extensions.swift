//
//  MatchEntity+Extensions.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import Foundation
import CoreData

extension MatchEntity {

    func toMatch() -> Match {
        let result = (self.homeScore != 0 || self.awayScore != 0) ? MatchResult(home: Int(self.homeScore), away: Int(self.awayScore)) : nil

        let status = MatchStatus(rawValue: self.status ?? "") ?? .preMatch

        return Match(
            id: self.id != 0 ? Int(self.id) : nil,
            homeTeam: self.homeTeam,
            awayTeam: self.awayTeam,
            homeTeamAvatar: self.homeTeamAvatar,
            awayTeamAvatar: self.awayTeamAvatar,
            date: self.date,
            status: status,
            currentTime: self.currentTime,
            result: result,
            sportId: self.sportId != 0 ? Int(self.sportId) : nil,
            competitionId: self.competitionId != 0 ? Int(self.competitionId) : nil
        )
    }

    static func from(match: Match, in context: NSManagedObjectContext) -> MatchEntity {
        let entity = MatchEntity(context: context)
        entity.id = Int64(match.id ?? 0)
        entity.homeTeam = match.homeTeam
        entity.awayTeam = match.awayTeam
        entity.homeTeamAvatar = match.homeTeamAvatar
        entity.awayTeamAvatar = match.awayTeamAvatar
        entity.date = match.date
        entity.status = match.status?.rawValue
        entity.currentTime = match.currentTime
        entity.homeScore = Int32(match.result?.home ?? 0)
        entity.awayScore = Int32(match.result?.away ?? 0)
        entity.sportId = Int64(match.sportId ?? 0)
        entity.competitionId = Int64(match.competitionId ?? 0)
        entity.lastUpdated = Date()
        return entity
    }
}

