//
//  Competition.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import Foundation

struct Competition: Codable, Identifiable, Hashable {
    let id: Int?
    let sportId: Int?
    let name: String?
    let competitionIconUrl: String?
}
