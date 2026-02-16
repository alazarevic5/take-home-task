//
//  HTTPRequest.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

struct HTTPRequest {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    let timeout: TimeInterval

    init(url: URL, method: HTTPMethod = .get, headers: [String: String] = [:], body: Data? = nil, timeout: TimeInterval = 30.0) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.timeout = timeout
    }
}
