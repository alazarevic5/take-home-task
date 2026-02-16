//
//  TimeFilterTabsView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct TimeFilterTabsView: View {
    let filters: [TimeFilter]
    let selectedFilter: TimeFilter
    let onSelect: (TimeFilter) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    TimeFilterTab(title: filter.displayName, isSelected: filter == selectedFilter) {
                        onSelect(filter)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}


