//
//  BookTrackerApp.swift
//  BookTracker
//
//  Created by Sami Hatna on 03/07/2021.
//

import SwiftUI

@main
struct BookTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
