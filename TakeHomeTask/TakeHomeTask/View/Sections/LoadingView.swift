//
//  LoadingView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 16.2.26..
//

import SwiftUI

struct MozzartLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primaryYellow))
                .scaleEffect(1.5)

            Text("Učitavanje...")
                .font(MFonts.bodyFont)
                .foregroundColor(.contentGray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
