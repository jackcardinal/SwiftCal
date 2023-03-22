//
//  SwiftCalApp.swift
//  SwiftCal
//
//  Created by Jack Cardinal on 3/9/23.
//

import SwiftUI

@main
struct SwiftCalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                CalendarView()
                    .tabItem { Label("Calendar", systemImage: "calendar") }
                    .foregroundColor(.accentColor)
                StreakView()
                    .tabItem { Label("Streak", systemImage: "swift") }
                    .foregroundColor(.accentColor)

            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
