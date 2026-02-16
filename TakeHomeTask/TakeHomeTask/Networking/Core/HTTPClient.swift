//
//  HTTPClient.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

protocol HTTPClientProtocol {
    func execute(_ request: HTTPRequest) async throws -> HTTPResponse
}

final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func execute(_ request: HTTPRequest) async throws -> HTTPResponse {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = request.timeout

        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if let body = request.body {
            urlRequest.httpBody = body
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            let headers: [String: String] = Dictionary(uniqueKeysWithValues:
                httpResponse.allHeaderFields.compactMap { key, value in
                    guard let stringKey = key as? String else { return nil }
                    return (stringKey, "\(value)")
                }
            )

            return HTTPResponse(data: data, statusCode: httpResponse.statusCode, headers: headers)

        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
