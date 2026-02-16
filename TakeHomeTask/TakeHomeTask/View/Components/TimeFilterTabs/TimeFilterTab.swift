//
//  TimeFilterTab.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct TimeFilterTab: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    private let tabWidth: CGFloat = 120

    private var foregroundColor: Color {
        isSelected ? .contentOnFillPrimary : .contentOnFillTertiary
    }

    private var backgroundColor: Color {
        isSelected ? .primaryYellowColor : .secondaryGray
    }

    var body: some View {
        Button(action: onTap) {
            content
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .frame(minWidth: tabWidth)
    }

    private var content: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(foregroundColor)
            .padding(16)
            .background(background)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
    }
}
