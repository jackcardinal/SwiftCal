//
//  ContentView.swift
//  SwiftCal
//
//  Created by Jack Cardinal on 3/9/23.
//

import SwiftUI
import CoreData
import WidgetKit

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)",
                               Date().startOfCaledarWithPrefixDays as CVarArg,
                               Date().endOfMonth as CVarArg),
        animation: .default)
    private var days: FetchedResults<Day>
    

    var body: some View {
        NavigationView {
            VStack {
                CalendarHeaderView()
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        if day.date!.monthInt != Date().monthInt {
                            Text("")
                        } else {
                            Text(day.date!.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .foregroundColor(day.didStudy ? .orange : .secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background {
                                    Circle()
                                        .foregroundColor(day.didStudy ? .orange.opacity(0.3) : .orange.opacity(0))
                                        .opacity(20)
                                }
                                .onTapGesture {
                                    if day.date!.dayInt <= Date().dayInt {
                                        day.didStudy.toggle()
                                        
                                        do {
                                            try viewContext.save()
                                            WidgetCenter.shared.reloadTimelines(ofKind: "SwiftCalWidget")
                                            print("👆🏼 \(day.date!.dayInt) is marked studied.")
                                        } catch {
                                            print("Failed to save context")
                                        }
                                    } else {
                                        print("You can't study in the future")
                                    }
                                }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
            .onAppear {
                if days.isEmpty {
                    createMonthDays(for: .now.startOfPreviousMonth)
                    createMonthDays(for: .now)
                } else if days.count < 10 {
                    createMonthDays(for: .now)
                }
            }

        }
    }
    
    func createMonthDays(for date: Date) {
        for dateOffSet in 0..<date.numberOfDaysInMonth {
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dateOffSet, to: date.startOfMonth)
            newDay.didStudy = false
        }
        
        do {
            try viewContext.save()
            print("✅ \(date.monthFullName) days created")
        } catch {
            print("Failed to save context")
        }
    }

    
//    let startDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
//    for dateOffSet in 0..<30 {
//        let newDay = Day(context: viewContext)
//        newDay.date = Calendar.current.date(byAdding: .day, value: dateOffSet, to: startDate)
//        newDay.didStudy = Bool.random()
//    }
//    do {
//        try viewContext.save()
//    } catch {
//
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    }
}


//                                if Calendar.current.isDateInToday(Date.now) {
//                                    Circle().stroke(2.0)
//                                        .foregroundColor(day.didStudy ? .orange.opacity(0.3) : .orange.opacity(0))
//                                        .opacity(20)
//                                }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
