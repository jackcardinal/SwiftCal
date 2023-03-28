//
//  CalendarHeaderView.swift
//  SwiftCal
//
//  Created by Jack Cardinal on 3/27/23.
//

import SwiftUI

struct CalendarHeaderView: View {
    
    let daysOfWeek = ["S","M","T","W","Th","F","S",]
    //default value in case you don't pass in a different font
    var font: Font = .body
    
    var body: some View {
        HStack{
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(font)
                    .fontWeight(.black)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView()
    }
}
