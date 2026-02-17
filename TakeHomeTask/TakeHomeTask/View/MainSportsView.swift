//
//  MainSportsView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import SwiftUI

struct MainSportsView: View {

    @StateObject internal var viewModel = SportsViewModel()

    var body: some View {
        ZStack {
            Color.defaultBackground.ignoresSafeArea()

            ScrollView {
                sportsTabs
                VStack(spacing: 20) {
                    liveSection
                    prematchSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .refreshable { viewModel.refreshData() }
    }
}

#Preview {
    MainSportsView()
}
