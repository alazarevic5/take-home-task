//
//  PrematchMatchCard.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct PrematchMatchCard: View {
    let match: Match
    let competition: Competition?
    let timeLabel: String
    
    init(match: Match, competition: Competition? = nil, timeLabel: String = "") {
        self.match = match
        self.competition = competition
        self.timeLabel = timeLabel
    }
    
    var body: some View {
        HStack(spacing: 0) {
            teamView(
                name: match.homeTeam,
                avatarUrl: match.homeTeamAvatar
            )
            
            Spacer()
            
            centerInfo
            
            Spacer()
            
            teamView(
                name: match.awayTeam,
                avatarUrl: match.awayTeamAvatar
            )
        }
        .padding(20)
        .background(.offerCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.cardBorder, lineWidth: 1)
        )
    }
    
    private func teamView(name: String?, avatarUrl: String?) -> some View {
        VStack(spacing: 8) {
            SVGImageView(
                urlString: avatarUrl,
                size: CGSize(width: 56, height: 56),
                tintColor: nil
            )
            .background(Color.gray.opacity(0.1))
            .clipShape(Circle())
            
        Text(name ?? "")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)
        }
    }
        
    private var centerInfo: some View {
        VStack(spacing: 6) {
            SVGImageView(
                urlString: competition?.competitionIconUrl,
                size: CGSize(width: 24, height: 24),
                tintColor: nil
            )
            
            Text(competition?.name ?? "")
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .lineLimit(1)
            
            Text(match.date?.formattedTime ?? "")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 4)
        }
        .frame(minWidth: 100)
    }
    
}

#Preview {
    VStack(spacing: 12) {
        PrematchMatchCard(
            match: Match(
                id: 1,
                homeTeam: "Chelsea",
                awayTeam: "Leicester C",
                homeTeamAvatar: nil,
                awayTeamAvatar: nil,
                date: "2024-02-17 20:15",
                status: .preMatch,
                currentTime: nil,
                result: nil,
                sportId: 1,
                competitionId: 1
            ),
            competition: Competition(
                id: 1,
                sportId: 1,
                name: "Premier League",
                competitionIconUrl: nil
            ),
            timeLabel: "Sutra"
        )
        
        PrematchMatchCard(
            match: Match(
                id: 2,
                homeTeam: "Real Madrid",
                awayTeam: "Barcelona",
                homeTeamAvatar: nil,
                awayTeamAvatar: nil,
                date: "2024-02-17 15:30",
                status: .preMatch,
                currentTime: nil,
                result: nil,
                sportId: 1,
                competitionId: 2
            ),
            competition: Competition(
                id: 2,
                sportId: 1,
                name: "Spain La Liga",
                competitionIconUrl: nil
            ),
            timeLabel: "Sutra"
        )
    }
    .padding()
    .background(Color("bgPrimary"))
}
