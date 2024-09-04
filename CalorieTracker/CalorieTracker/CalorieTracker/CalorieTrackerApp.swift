//
//  CalorieTrackerApp.swift
//  CalorieTracker
//
//  Created by ŞEVVAL on 29.07.2024.
//

import SwiftUI

@main
struct CalorieTrackerApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
