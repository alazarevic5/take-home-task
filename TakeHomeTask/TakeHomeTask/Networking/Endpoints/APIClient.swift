//
//  ApiClient.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

class APIClient {
    private let baseURL = "https://take-home-api-7m87.onrender.com/api"

    func fetchData<T: Codable>(from path: String, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
