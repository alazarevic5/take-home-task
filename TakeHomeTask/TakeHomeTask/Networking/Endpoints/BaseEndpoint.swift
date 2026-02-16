//
//  BaseEndpoint.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

protocol APIEndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [String: Any]? { get }
}

extension APIEndpointProtocol {
    var url: URL? {
        guard var components = URLComponents(string: baseURL + path) else { return nil }

        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }

        return components.url
    }

    var baseURL: String {
        return "https://take-home-api-7m87.onrender.com/api"
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }

    var queryParameters: [String: Any]? {
        return nil
    }
}
