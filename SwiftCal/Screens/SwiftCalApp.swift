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
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tabItem { Label("Calendar", systemImage: "calendar") }
                    .tag(0)
                    .foregroundColor(.accentColor)
                StreakView()
                    .tabItem { Label("Streak", systemImage: "swift") }
                    .tag(1)
                    .foregroundColor(.accentColor)

            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "calendar" ? 0 : 1
            }
        }
    }
}
