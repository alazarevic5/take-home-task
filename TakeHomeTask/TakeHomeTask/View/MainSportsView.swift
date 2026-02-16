//
//  MainSportsView.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import SwiftUI

struct MainSportsView: View {
    
    @StateObject private var viewModel = SportsViewModel()
    @State private var selectedTab = 0
    @State private var selectedSportId: Int? = nil
    
    var body: some View {
        ZStack {
            Color.bgPrimary
            VStack (spacing: 16) {
                
                SportsTabView(sports: viewModel.availableSports, selectedId: viewModel.selectedSportId, onSelect: { viewModel.selectSport(withId: $0)})
                    .padding(.trailing, 0)
            
                VStack (spacing: 16) {
                    SectionHeader(title: "Mečevi uživo")

                }.padding(16)
                
                
                Spacer()
                
            }.padding(.vertical, 16)
        }
        .onAppear {
            
        }
        
    }
}
