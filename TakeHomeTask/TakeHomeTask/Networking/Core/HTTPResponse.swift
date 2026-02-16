//
//  HTTPResponse.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

public struct HTTPResponse {
    let data: Data
    let statusCode: Int
    let headers: [String: String]
}

