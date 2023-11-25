//
//  UserSettingsView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI
import Firebase

struct DriverSettingsView: View {
    @State private var selectedLocation = "North"
    @State private var autoConfirm = true
    @State private var availableSeats = 1
    @State private var fname: String = ""
    @State private var lname: String = ""
    @EnvironmentObject var viewModel: MainViewModel


    let locations = ["North", "Rand", "No Preference"]
    
    @State private var dbLocation = ""
    @State private var dbAutoConfirm = true
    @State private var dbAvailableSeats = 4
    @State private var dbFirstName = ""
    @State private var dbLastName = ""

    var body: some View {
        Form {
            Section(header: Text("Driver Settings")) {
                
                TextField("First Name", text: $fname).padding()
                TextField("Last Name", text:$lname).padding()
                
                // Dropdown menu for selecting default pickup location
                Picker("Default Pickup Location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                // Toggle for default attendance confirmation
                Toggle("Automatic Attendance Confirmation", isOn: $autoConfirm)

                // Stepper for selecting available seats (for drivers or admins)
                Stepper("Available Seats: \(availableSeats)", value: $availableSeats, in: 1...5)
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
        .navigationBarTitle("Driver Settings")
        .onAppear {
            // Fetch user preferences from the Realtime Database when the view appears
            fetchDriverPreferences()
        }
    }

    func signOut() {
        do {
            try FirebaseUtil.shared.auth.signOut()
            print("signed out?")
            self.viewModel.handleSignOut()
            // Clear user-related data from UserDefaults or perform any additional cleanup
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    private func fetchDriverPreferences() {
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
                dbFirstName = userData["fname"] as? String ?? ""
                dbLastName = userData["lname"] as? String ?? ""
                // Set the current values to the fetched values
                selectedLocation = dbLocation
                autoConfirm = dbAutoConfirm
                availableSeats = dbAvailableSeats
                fname = dbFirstName
                lname = dbLastName
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
            "fname": fname,
            "lname": lname,
            "default_location": selectedLocation,
            "default_attendance_confirmation": autoConfirm,
            "default_seats": availableSeats
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

struct DriverSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DriverSettingsView()
    }
}

