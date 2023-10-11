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

    private func signOut() {
        // Implement your sign-out logic here
    }
}

struct DriverSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DriverSettingsView()
    }
}
