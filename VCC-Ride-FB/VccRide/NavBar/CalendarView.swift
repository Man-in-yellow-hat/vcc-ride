//
//  CalendarView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

//import SwiftUI
//
//struct CalendarView: View {
//    var body: some View {
//        Text("CALENDAR!")
//    }
//}
//
//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}

import SwiftUI
import Firebase


struct CalendarView: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel(dateFetcher: FirebaseDateFetcher())
    
    @State private var attendingDates = [String:Bool]()
    @State private var autoConfirm = false
    @State private var name: String = ""
    @State private var location: String = ""
    let locations = ["North", "Rand"]

    // Firebase reference for user preferences
    private let userPreferencesRef = Database.database().reference().child("Fall23-Users")

    @State private var dbAttendingDates = [String:Bool]()
    @State private var dbAutoConfirm = false
    
    var body: some View {
        Form {
            Section {
                Text("Dates")
                VStack {
                    if !practiceDateViewModel.practiceDates.isEmpty {
                        List(practiceDateViewModel.practiceDates, id: \.self) { date in Toggle(date, isOn: Binding(
                                            get: { attendingDates[date] ?? false },
                                            set: { newValue in
                                                attendingDates[date] = newValue
                                            }
                            ))
                        }
                    } else {
                        Text("No practice dates available.")
                    }
                    
                }
                .padding()
                .onAppear {
                    if practiceDateViewModel.practiceDates.isEmpty {
                        print("fetching dates, try not to do this too often!")
                        practiceDateViewModel.fetchExistingDates()
                    }
                }
            }
            Section {
                Button(action: {
                    // Save the updated preferences to the Realtime Database
                    savePreferences()
                }) {
                    Text("Save Preferences")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationBarTitle("Rider Settings")
        .onAppear {
            // Fetch user preferences from the Realtime Database when the view appears
            fetchUserPreferences()
        }
    }
    
    
    private func fetchUserPreferences() {
        guard let userID = Auth.auth().currentUser?.uid else {
            //TODO: Handle the case when there is no logged-in user
            return
        }

        // Firebase reference for the user's data
        let userRef = Database.database().reference().child("Fall23-Users").child(userID)

        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                dbAttendingDates = userData["attending_dates"] as? Dictionary ?? [String:Bool]()
                dbAutoConfirm = userData["default_attendance_confirmation"] as? Bool ?? true
                name = userData["name"] as? String ?? ""
                location = userData["default_location"] as? String ?? ""
                // Set the current values to the fetched values
                attendingDates = dbAttendingDates
            }
        }
    }

    private func savePreferences() {
        guard let userID = Auth.auth().currentUser?.uid else {
            //TODO: Handle the case when there is no logged-in user
            return
        }
        
        let userRef = Database.database().reference().child("Fall23-Users").child(userID)

        let updatedPreferences: [String: Any] = [
            "attending_dates": attendingDates
        ]

        userRef.updateChildValues(updatedPreferences) { error, _ in
            if let error = error {
                // Handle the error when updating preferences fails
                print("Error updating preferences: \(error.localizedDescription)")
            } else {
                // Preferences updated successfully
                print("Preferences updated successfully!")
                // You can also update the original values to match the saved values
                dbAttendingDates = attendingDates
            }
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
//                var location = userData["default_location"] as? String ?? ""
                var role = userData["role"] as? String ?? ""
                let seats = userData["default_seats"] as? Int ?? 1
                print(userData)
                
                if role == "admin" {
                    role = "driver" // FOR NOW TODO: MAKE BETTER
                }
                
                var setUserData: [String: Any]
                if role == "driver" {
                    setUserData = [
                        "filled_seats": 0,
                        "name": self.name,
                        "preference": self.location,
                        "seats": seats
                    ]
                } else { // role == "rider"
                    setUserData = [
                        "in_car": false,
                        "name": self.name,
                        "seats": seats
                    ]
                }
                
                if location == "No Preference" {
                    location = "no_pref"
                }
                
                print(location, role, seats)
                let childList = location.lowercased() + "_" + role + "s"
                
                for date in attendingDates {
                    print("attending: \(date.key)")
                    let practiceRef = Database.database().reference().child("Fall23-Practices").child(date.key)
                    
                    practiceRef.child(childList).child(userID).setValue(setUserData)
                }
                

                // Remove the user from the appropriate list when unselecting a practice
                for date in practiceDateViewModel.practiceDates {
                    if attendingDates[date] == false && dbAttendingDates[date] == true {
                        let practiceRef = Database.database().reference().child("Fall23-Practices").child(date)
                        practiceRef.child(childList).child(userID).removeValue()
                        print("removing: \(date)")
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
