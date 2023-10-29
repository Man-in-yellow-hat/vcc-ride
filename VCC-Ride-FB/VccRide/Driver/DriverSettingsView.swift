//
//  UserSettingsView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI

struct DriverSettingsView: View {
    @State private var selectedLocation = "North"
    @State private var autoConfirm = true
    @State private var availableSeats = 1
    @EnvironmentObject var viewModel: MainViewModel


    let locations = ["North", "Rand", "No Preference"]

    var body: some View {
        Form {
            Section(header: Text("Driver Settings")) {
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
                Button(action: signOut) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Driver Settings")
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
}

struct DriverSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DriverSettingsView()
    }
}

