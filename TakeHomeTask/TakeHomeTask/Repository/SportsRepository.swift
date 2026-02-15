//
//  SportsRepository.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

class SportsRepository {
    func fetchSports() async throws -> [Sport] {
        let client = APIClient()
        return try await client.fetchData(from: "/sports", type: [Sport].self)
    }

    func fetchCompetitions() async throws -> [Competition] {
        let client = APIClient()
        return try await client.fetchData(from: "/competitions", type: [Competition].self)
    }

    func fetchMatches() async throws -> [Match] {
        let client = APIClient()
        return try await client.fetchData(from: "/matches", type: [Match].self)
    }
}
