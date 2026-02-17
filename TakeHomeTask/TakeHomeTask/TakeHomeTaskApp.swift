//
//  TakeHomeTaskApp.swift
//  TakeHomeTask
//
//  Created by Aleksandra Lazarevic on 15.2.26..
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

@main
struct TakeHomeTaskApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
