//
//  Sport.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

struct Sport: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let sportIconUrl: String?
}
