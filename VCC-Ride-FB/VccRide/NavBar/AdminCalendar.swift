//
//  AdminCalendar.swift
//  VccRide
//
//  Created by Nathan King on 10/7/23.
//

import SwiftUI

struct ExistingDatesView: View {
    @ObservedObject var viewModel: PracticeDateViewModel
    @State private var dates: [String] = []

    var body: some View {
        VStack {
            Text("Existing Dates")
                .font(.title)
            
            List(dates, id: \.self) { date in
                Text(date)
            }
            .onAppear {
                viewModel.fetchExistingDates { fetchedDates in
                    self.dates = fetchedDates
                }
            }
        }
        .padding()
    }
}


struct AdminCalendar: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel()
    @State private var newDate: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ExistingDatesView(viewModel: practiceDateViewModel)
                
                TextField("Enter date (e.g., oct4)", text: $newDate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add Practice Date") {
                    practiceDateViewModel.addPracticeDate(date: newDate)
                    newDate = ""
                }
            }
            .padding()
            .navigationBarTitle("Practice Dates")
        }
    }
}


struct AdminCalendar_Previews: PreviewProvider {
    static var previews: some View {
        AdminCalendar()
    }
}
