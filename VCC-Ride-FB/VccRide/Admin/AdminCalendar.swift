//
//  AdminCalendar.swift
//  VccRide
//
//  Created by Nathan King on 10/7/23.
//

import SwiftUI


struct AdminCalendar: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel()
    //@State private var newDate: String = ""
    @State var newDate = Date()
    @State var datePickerVisible = false
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    /*
                     TextField("Enter date (e.g., oct4)", text: $newDate)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     
                     Button("Add Practice Date") {
                     practiceDateViewModel.addPracticeDate(date: newDate)
                     newDate = ""
                     }
                     */
                    
                    Button("Add Practice Date") {
                        datePickerVisible = true
                    }
                } //VStack
                .padding()
                .navigationBarTitle("Practice Dates")
                .onAppear {
                    if practiceDateViewModel.practiceDates.isEmpty {
                        print("fetching dates, try not to do this too often!")
                        practiceDateViewModel.fetchExistingDates()
                    }
                }
                .zIndex(1)
                if datePickerVisible {
                    VStack{
                        Spacer()
                        HStack{
                            Button("Cancel", action: {
                                datePickerVisible = false
                            }).padding()
                            Spacer()
                            Button("Done", action: {
                                datePickerVisible = false
                                dateFormatter.dateStyle = .medium
                                practiceDateViewModel.addPracticeDate(date: dateFormatter.string(from: newDate))
                            }).padding()
                        }
                        DatePicker("", selection: $newDate).datePickerStyle(GraphicalDatePickerStyle())
                    }.background(Color(UIColor.secondarySystemBackground))
                        .zIndex(2)
                }
                
            } //ZStack
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
