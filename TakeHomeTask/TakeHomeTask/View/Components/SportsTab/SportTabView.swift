//
//  SportsTabView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct SportsTabView: View {
    let sports: [Sport]
    let selectedId: Int?
    let onSelect: (Int) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sports) { sport in
                    SportTab(name: sport.name, iconUrl: sport.sportIconUrl, isSelected: sport.id == selectedId) {
                        onSelect(sport.id)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}
