//
//  SportsRepository+Filters.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

extension SportsRepository {

    func getMatches(forSportId sportId: Int) -> [Match] {
        return matches.filter { $0.sportId == sportId }
    }

    // (LIVE, PRE_MATCH, FINISHED)
    func getMatches(withStatus status: MatchStatus) -> [Match] {
        return matches.filter { $0.status == status }
    }

    func getLiveMatches() -> [Match] {
        return getMatches(withStatus: .live)
    }

    func getUpcomingMatches() -> [Match] {
        return getMatches(withStatus: .preMatch)
    }
}
