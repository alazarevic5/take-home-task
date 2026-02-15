//
//  MainSportsView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import SwiftUI

struct MainSportsView: View {
    
    var body: some View {
        VStack {
            Text("Proba")
        }.onAppear {
            Task {
                let repo = SportsRepository()

                print("Sports:", try await repo.fetchSports())
                print("Competitions:", try await repo.fetchCompetitions())
                print("Matches:", try await repo.fetchMatches())
            }
        }

    }
    
}
