//
//  TimeFilter.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

public enum TimeFilter: String, CaseIterable {
    case today = "Danas"
    case tomorrow = "Sutra"
    case weekend = "Vikend"
    case upcoming = "Sledeće"

    var displayName: String {
        return self.rawValue
    }
}
