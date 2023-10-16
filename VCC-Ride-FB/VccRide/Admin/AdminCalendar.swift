//
//  AdminCalendar.swift
//  VccRide
//
//  Created by Nathan King on 10/7/23.
//

import SwiftUI


struct AdminCalendar: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel()
    @State private var newDate: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if !practiceDateViewModel.practiceDates.isEmpty {
                    List {
                        ForEach(practiceDateViewModel.practiceDates, id: \.self) { date in
                            Text(date)
                        }
                        .onDelete(perform: delete)
                    }
                    
                    //List(practiceDateViewModel.practiceDates, id: \.self) { date in
                    //    Text(date)
                    //}
                } else {
                    Text("No practice dates available.")
                }
                
                TextField("Enter date (e.g., oct4)", text: $newDate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add Practice Date") {
                    practiceDateViewModel.addPracticeDate(date: newDate)
                    newDate = ""
                }
            }
            .padding()
            .navigationBarTitle("Practice Dates")
            .onAppear {
                if practiceDateViewModel.practiceDates.isEmpty {
                    print("fetching dates, try not to do this too often!")
                    practiceDateViewModel.fetchExistingDates()
                }
            }
        }
    }
    
    // Function for deleting date
    private func delete(with indexSet: IndexSet) {
        indexSet.forEach {i in practiceDateViewModel.deletePracticeDate(date: practiceDateViewModel.practiceDates[i])}
        indexSet.forEach {i in practiceDateViewModel.practiceDates.remove(at: i)}}
}



struct AdminCalendar_Previews: PreviewProvider {
    static var previews: some View {
        AdminCalendar()
    }
}
