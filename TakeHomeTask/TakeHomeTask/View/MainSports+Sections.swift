//
//  MainSports+Sections.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

extension MainSportsView {

    var sportsTabs: some View {
        SportsTabsView(sports: viewModel.availableSports, selectedId: viewModel.selectedSportId, onSelect: viewModel.selectSport(withId:))
    }

    @ViewBuilder
    var liveSection: some View {
        let matches = viewModel.getLiveMatches()
        if !matches.isEmpty {
            LiveMatchesSection(title: "MEČEVI UŽIVO", matches: matches, getCompetition: viewModel.getCompetition(for:))
        }

        if viewModel.isLoading && !viewModel.hasOfflineData {
            ProgressView()
                .tint(.primaryYellowColor)
                .padding(40)
        }
    }

    var prematchSection: some View {
        PrematchSection(
            title: "PREMATCH PONUDA",
            filters: TimeFilter.allCases,
            selectedFilter: viewModel.selectedTimeTab,
            onSelectFilter: viewModel.selectTimeTab(_:) ,
            matches: viewModel.filteredMatches,
            getCompetition: viewModel.getCompetition(for:),
            timeLabel: viewModel.selectedTimeTab.displayName
        )
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    var prematchContent: some View {
        if viewModel.filteredMatches.isEmpty {
            emptyPrematchState
        } else {
            prematchList
        }
    }

    var emptyPrematchState: some View {
        Text("Nema mečeva za izabrani filter")
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
    }

    var prematchList: some View {
        ForEach(viewModel.filteredMatches, id: \.id) { match in
            PrematchMatchCard(
                match: match,
                competition: viewModel.getCompetition(for: match.competitionId ?? 0),
                timeLabel: viewModel.selectedTimeTab.displayName
            )
        }
    }
}
