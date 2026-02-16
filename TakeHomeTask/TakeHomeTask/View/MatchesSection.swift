//
//  MatchesSection.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct MatchesSection: View {
    let title: String
    let matches: [Match]
    let getCompetition: (Int) -> Competition?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title)

            if matches.isEmpty {
                Text("Nema dostupnih mečeva")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 20)
            } else {
                ForEach(matches, id: \.id) { match in
                    LiveMatchCard(
                        match: match,
                        competition: match.competitionId.flatMap { getCompetition($0) }
                    )
                }
            }
        }
    }
}
