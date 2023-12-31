//
//  AdminCalendar.swift
//  VccRide
//
//  Created by Nathan King on 10/7/23.
//

import SwiftUI


struct AdminCalendar: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel(dateFetcher: FirebaseDateFetcher())
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
                        
                    } else {
                        Text("No practice dates available.")
                    }
                    
                    Button("Add Practice Date") {
                        datePickerVisible = true
                    }
                    Text("You can select your attendance in settings.")
                        .frame(maxWidth: .infinity)
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
                                let filteredChar = newDate.formatted(Date.FormatStyle().month(.abbreviated).day(.twoDigits)).filter { !$0.isWhitespace }
                                practiceDateViewModel.addPracticeDate(date: String(filteredChar))
                            }).padding()
                        }
                        DatePicker("", selection: $newDate, displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle())
                    }.background(Color(UIColor.secondarySystemBackground))
                        .zIndex(2)
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
