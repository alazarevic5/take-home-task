//
//  TimeFilterTabsView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

/// filtering competitions - today, tomorrow, next ...
struct TimeFilterTabsView: View {
    let filters: [TimeFilter]
    let selectedFilter: TimeFilter
    let onSelect: (TimeFilter) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(filters, id: \.self) { filter in
                    TimeFilterTab(title: filter.displayName, isSelected: filter == selectedFilter) {
                        onSelect(filter)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
    }
}


