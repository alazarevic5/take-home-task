//
//  StringExtension.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

public extension String {
    var formattedTime: String {
        // "yyyy-MM-dd HH:mm" -> vreme
        let components = self.split(separator: " ")
        if components.count == 2 {
            return String(components[1])
        }
        
        return "--:--"
    }
}
