//
//  MainSportsView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import SwiftUI

struct MainSportsView: View {
    
    @StateObject private var viewModel = SportsViewModel()
    @State private var selectedTab = 0
    @State private var selectedSportId: Int? = nil
    
    var body: some View {
        ZStack {
            Color(.bgPrimary).ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    // sportovi
                    SportsTabsView(
                        sports: viewModel.availableSports,
                        selectedId: viewModel.selectedSportId,
                        onSelect: { viewModel.selectSport(withId: $0) }
                    )
                    
                    VStack {
                        VStack(spacing: 20) {
                            // live mecevi
                            let liveMatches = viewModel.getLiveMatches()
                            if !liveMatches.isEmpty {
                                MatchesSection(
                                    title: "MEČEVI UŽIVO",
                                    matches: liveMatches,
                                    getCompetition: { viewModel.getCompetition(for: $0) }
                                )
                            }
                            
                            if viewModel.isLoading && !viewModel.hasOfflineData {
                                ProgressView()
                                    .tint(.primaryYellowColor)
                                    .padding(40)
                            }
                        }

                        
                        VStack(alignment: .leading, spacing: 20) {
                            // prematch 
                            SectionHeader(title: "PREMATCH PONUDA")

                            TimeFilterTabsView(
                                filters: TimeFilter.allCases,
                                selectedFilter: viewModel.selectedTimeTab,
                                onSelect: { viewModel.selectTimeTab($0) }
                            )
                            .padding(.horizontal, -16)

                            if viewModel.filteredMatches.isEmpty {
                                Text("Nema mečeva za izabrani filter")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                            } else {
                                ForEach(viewModel.filteredMatches, id: \.id) { match in
                                    PrematchMatchCard(
                                        match: match,
                                        competition: viewModel.getCompetition(for: match.competitionId ?? 0),
                                        timeLabel: viewModel.selectedTimeTab.displayName
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .refreshable {
            viewModel.refreshData()
        }
    }
}

#Preview {
    MainSportsView()
}
