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
        HStack (spacing: 8) {
            icon
            label
        }
        .padding(12)
        .background(background)
    }
    
    private var foregroundColor: Color {
        isSelected ? .contentOnFillPrimaryColor : .contentOnFillSecondaryColor
    }
    
    private var backgroundColor: Color {
        isSelected ? .primaryYellowColor : .secondaryGrayColor
    }
    
    @ViewBuilder
    private var icon: some View {
        Group {
            if let url = iconUrl, let imageUrl = URL(string: url) {
                AsyncImage(url: imageUrl) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(systemName: "sportscourt")
                }
            } else {
                Image(systemName: "sportscourt")
            }
        }
        .frame(width:20, height: 20)
        .foregroundColor(foregroundColor)
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
