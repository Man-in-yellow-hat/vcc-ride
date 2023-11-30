//
//  SettingsView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @ObservedObject private var viewModel = MainViewModel.shared

    @State private var selectedLocation = "North"
    @State private var autoConfirm = true
    @State private var availableSeats = 1
    @State private var fname: String = ""
    @State private var lname: String = ""

    @State private var deleteAlert = false
    @State private var deleteConfirmationText = ""
    @State private var flashColor: Color = Color(UIColor.systemGray5)

    let locations = ["North", "Rand", "No Preference"]

    @State private var dbLocation = ""
    @State private var dbAutoConfirm = true
    @State private var dbAvailableSeats = 4
    @State private var dbFirstName = ""
    @State private var dbLastName = ""

    var role: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    
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
                    if role == "driver" || role == "admin" {
                        Stepper("Available Seats: \(availableSeats)", value: $availableSeats, in: 1...5)
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
                
                Section {
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    if (!deleteAlert) {
                        Button(action: {
                            deleteAlert = true
                        }) {
                            Text("Delete Account")
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("Are you sure you want to delete your account? This action cannot be undone.")
                        TextField("Type 'delete'", text: $deleteConfirmationText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        HStack {
                            Button(action: {
                                deleteAlert = false
                                print("CANCELLING")
                            }) {
                                Text("Cancel")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(UIColor.systemGray5))
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain) // Add this modifier to the Cancel button
                            
                            Spacer()
                            
                            Button(action: {
                                if deleteConfirmationText.lowercased() == "delete" && deleteAlert {
                                    deleteAccount()
                                    print("DELETING")
                                } else {
                                    // Flash the button background red
                                    withAnimation {
                                        flashColor = .red
                                    }
                                    // Reset the button background color after a short delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            flashColor = Color(UIColor.systemGray5) // Lighter gray
                                        }
                                    }
                                }
                            }) {
                                Text("Confirm Delete")
                                    .foregroundColor(.red)
                                    .padding()
                                    .background(flashColor)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain) // Add this modifier to the Confirm Delete button
                            
                        }
                    }
                }
            }
            .navigationBarTitle("\(role.capitalized) Settings")
            .onAppear {
                // Fetch user preferences from the Realtime Database when the view appears
                fetchPreferences()
            }
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            // User is not logged in or doesn't exist
            return
        }

        // Save the user ID before deleting the user
        let userID = user.uid

        // Remove the user's data from Fall23-Users
        let usersRef = Database.database().reference().child("Fall23-Users").child(userID)
        usersRef.removeValue { error, _ in
            if let error = error {
                // Error deleting user from the "Fall23-Users" list
                print("Error deleting user from Fall23-Users: \(error.localizedDescription)")
            } else {
                // User deleted from "Fall23-Users" list successfully
                print("User deleted from Fall23-Users successfully")
            }
        }

        // Delete user from Auth as well
        user.delete { error in
            if let error = error {
                print(error)
            } else {
                viewModel.handleSignOut()
            }
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

    private func fetchPreferences() {
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

#Preview {
    SettingsView(role: "rider")
}
