//
//  Match.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

struct Match: Codable, Identifiable, Hashable {
    let id: Int?
    let homeTeam: String?
    let awayTeam: String?
    let homeTeamAvatar: String?
    let awayTeamAvatar: String?
    let date: String?
    let status: MatchStatus?
    let currentTime: String?
    let result: MatchResult?
    let sportId: Int?
    let competitionId: Int?
}

struct MatchResult: Codable, Hashable {
    let home: Int?
    let away: Int?
}

enum MatchStatus: String, Codable, CaseIterable {
    case preMatch = "PRE_MATCH"
    case live = "LIVE"
    case finished = "FINISHED"

    var displayName: String {
        switch self {
        case .preMatch:
            return "Upcoming"
        case .live:
            return "Live"
        case .finished:
            return "Finished"
        }
    }
}
