//
//  RiderSettingsView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI
import Firebase


struct RiderSettingsView: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel()
    
    
    @State private var selectedLocation = "North"
    @State private var autoConfirm = true
    @State private var availableSeats = 1

    let locations = ["North", "Rand", "No Preference"]

    // Firebase reference for user preferences
    private let userPreferencesRef = Database.database().reference().child("Fall23-Users")

    @State private var dbLocation = ""
    @State private var dbAutoConfirm = true
    @State private var dbAvailableSeats = 4
    @State private var dbAttendingDates = [String:Bool]()
    
    var body: some View {
        Form {
            Section(header: Text("Rider Settings")) {
                // Dropdown menu for selecting default pickup location
                Picker("Default Pickup Location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                // Toggle for default attendance confirmation
                Toggle("Automatic Attendance Confirmation", isOn: $autoConfirm)
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

            Section {
                Button(action: signOut) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Rider Settings")
        .onAppear {
            // Fetch user preferences from the Realtime Database when the view appears
            fetchUserPreferences()
        }
    }
    

    private func signOut() {
        // Implement your sign-out logic here
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
                dbLocation = userData["default_location"] as? String ?? ""
                dbAutoConfirm = userData["default_attendance_confirmation"] as? Bool ?? true
                dbAvailableSeats = userData["default_seats"] as? Int ?? 1
                dbAttendingDates = userData["attendance_dates"] as? Dictionary ?? [String:Bool]()
                // Set the current values to the fetched values
                selectedLocation = dbLocation
                autoConfirm = dbAutoConfirm
                availableSeats = dbAvailableSeats
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
            "default_location": selectedLocation,
            "default_attendance_confirmation": autoConfirm,
            "default_seats": availableSeats,
        ]

        userRef.updateChildValues(updatedPreferences) { error, _ in
            if let error = error {
                // Handle the error when updating preferences fails
                print("Error updating preferences: \(error.localizedDescription)")
            } else {
                // Preferences updated successfully
                print("Preferences updated successfully!")
                // You can also update the original values to match the saved values
                dbLocation = selectedLocation
                dbAutoConfirm = autoConfirm
                dbAvailableSeats = availableSeats
            }
        }
    }

}

struct RiderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RiderSettingsView()
    }
}
