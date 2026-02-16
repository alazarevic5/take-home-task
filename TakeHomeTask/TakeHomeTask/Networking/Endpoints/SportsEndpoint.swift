//
//  SportsEndpoint.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

enum SportsEndpoint: APIEndpointProtocol {
    case list

    var path: String {
        switch self {
        case .list:
            return "/sports"
        }
    }
}
