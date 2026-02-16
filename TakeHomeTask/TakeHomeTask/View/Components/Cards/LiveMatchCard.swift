//
//  LiveMatchCard.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct LiveMatchCard: View {
    let match: Match
    let competition: Competition?
    let onTap: (() -> Void)?
    
    init(match: Match, competition: Competition? = nil, onTap: (() -> Void)? = nil) {
        self.match = match
        self.competition = competition
        self.onTap = onTap
    }
    
    var body: some View {
        VStack (spacing: 16) {
            header
            content
        }.padding(16)
            .background(Color.liveCardBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.cardBorderColor, lineWidth: 1)
            )
    }
    
    private var header: some View {
        HStack (spacing: 16) {
            competitionInfo.fixedSize(horizontal: true, vertical: false)
            statusBadge.fixedSize()
            Spacer()
        }
    }
    
    private var competitionInfo: some View {
        HStack(spacing: 6) {
            RemoteImage(url: competition?.competitionIconUrl, size: 16)

            if let name = competition?.name {
                Text(name)
                    .font(.system(size: 12))
                    .foregroundColor(.contentGrayColor)
            }
        }
    }
    @ViewBuilder
    private var statusBadge: some View {
        switch match.status {
        case .live:
            LiveBadge(currentTime: match.currentTime)
        default:
            EmptyView()
        }
    }
    
    private var content: some View {
        VStack {
            teamRow(name: match.homeTeam, avatarUrl: match.homeTeamAvatar, result: match.result?.home)
            teamRow(name: match.awayTeam, avatarUrl: match.awayTeamAvatar, result: match.result?.away)
        }
    }
    
    private func teamRow(name: String?, avatarUrl: String?, result: Int?) -> some View {
        HStack(spacing: 12) {
            RemoteImage(url: avatarUrl, size: 24)

            Text(name ?? "")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.contentWhiteColor)
                .lineLimit(1)
            
            Spacer()
            
            Text("\(result ?? 0)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.contentWhiteColor)
        }
    }
}
