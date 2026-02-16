//
//  MatchesEndpoint.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

enum MatchesEndpoint: APIEndpointProtocol {
    case list

    var path: String {
        switch self {
        case .list:
            return "/matches"
        }
    }

    var queryParameters: [String: Any]? {
        switch self {
        case .list:
            return nil
        }
    }
}
