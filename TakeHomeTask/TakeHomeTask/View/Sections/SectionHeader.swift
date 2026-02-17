//
//  SectionHeader.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let textColor: Color
    let accentColor: Color
    
    init(title: String, textColor: Color = .white, accentColor: Color = .primaryYellowColor) {
        self.title = title
        self.textColor = textColor
        self.accentColor = accentColor
    }
    
    var body: some View {
        HStack (spacing: 6) {
            rectangle
            sectionTitle
            Spacer()
        }
    }
    
    private var rectangle: some View {
        Rectangle()
            .fill(accentColor)
            .frame(width: 2, height: 16)
    }
    
    private var sectionTitle: some View {
        Text(title.uppercased())
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(textColor)
    }
}
