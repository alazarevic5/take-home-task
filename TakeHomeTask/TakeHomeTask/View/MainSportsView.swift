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
                                  .tint(Color("primaryYellow"))
                                  .padding(40)
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
