//
//  ContentView.swift
//  SwiftCal
//
//  Created by Jack Cardinal on 3/9/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        animation: .default)
    private var days: FetchedResults<Day>
    
    let daysOfWeek = ["S","M","T","W","Th","F","S",]

    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        Text(day.date!.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundColor(day.didStudy ? .orange : .secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background {
                                Circle()
                                    .foregroundColor(day.didStudy ? .orange.opacity(0.3) : .orange.opacity(0))
                                    .opacity(20)
                            }


                    }
                }
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()

        }
    }

}


//                                if Calendar.current.isDateInToday(Date.now) {
//                                    Circle().stroke(2.0)
//                                        .foregroundColor(day.didStudy ? .orange.opacity(0.3) : .orange.opacity(0))
//                                        .opacity(20)
//                                }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
