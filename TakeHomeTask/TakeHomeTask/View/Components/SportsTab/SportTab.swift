//
//  SportTab.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct SportTab: View {
    let name: String
    let iconUrl: String?
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            content
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private var content: some View {
        HStack(spacing: 8) {
            icon
            label
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 8)
        .background(background)
    }
    
    private var horizontalPadding: CGFloat {
        isSelected ? 16 : 12
    }
    
    private var foregroundColor: Color {
        isSelected ? .contentOnFillPrimaryColor : .contentOnFillSecondaryColor
    }
    
    private var backgroundColor: Color {
        isSelected ? .primaryYellowColor : .secondaryGrayColor
    }
    
    private var icon: some View {
        SVGImageView(
            urlString: iconUrl,
            size: CGSize(width: 20, height: 20),
            tintColor: foregroundColor
        )
    }
    
    @ViewBuilder
    private var label: some View {
        if isSelected {
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(foregroundColor)
        }
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(backgroundColor)
    }
}
