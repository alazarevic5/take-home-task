//
//  PrematchMatchSection.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct PrematchSection: View {

    let title: String
    let filters: [TimeFilter]
    let selectedFilter: TimeFilter
    let onSelectFilter: (TimeFilter) -> Void

    let matches: [Match]
    let getCompetition: (Int) -> Competition?

    let timeLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: title)

            TimeFilterTabsView(
                filters: filters,
                selectedFilter: selectedFilter,
                onSelect: onSelectFilter
            )
            .padding(.horizontal, -16)

            if matches.isEmpty {
                Text("Nema mečeva za izabrani filter")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(matches, id: \.id) { match in
                    PrematchMatchCard(
                        match: match,
                        competition: match.competitionId.flatMap { getCompetition($0) },
                        timeLabel: timeLabel
                    )
                }
            }
        }
    }
}
