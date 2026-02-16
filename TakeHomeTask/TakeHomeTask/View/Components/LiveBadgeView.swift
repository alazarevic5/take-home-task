//
//  LiveBadgeView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct LiveBadge: View {
    let currentTime: String?

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "play.fill")
                .font(.system(size: 8))
            Text(formattedTime)
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundColor(.greenAccentColor)
    }

    private var formattedTime: String {
        guard let time = currentTime, !time.isEmpty else { return "LIVE" }

        // ako ima minutazu
        if time.contains("'") {
            let minutes = Int(time.replacingOccurrences(of: "'", with: "")) ?? 0
            let half = minutes <= 45 ? "1" : "2"
            return "\(half). poluvreme - \(time)"
        }

        // za sve ostale
        return time
    }
}
