//
//  RiderSettingsView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI

struct RiderSettingsView: View {
    @State private var selectedLocation = "North"
    @State private var autoConfirm = true

    let locations = ["North", "Rand", "No Preference"]

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
                Button(action: signOut) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Rider Settings")
    }

    private func signOut() {
        // Implement your sign-out logic here
    }
}

struct RiderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RiderSettingsView()
    }
}
