//
//  RiderSettingsView.swift
//  VccRide
//
//  Created by Nathan King on 10/9/23.
//

import SwiftUI

class UserDates: ObservableObject {
    @Published var toggledDates: [String: Bool] = [:]
}

struct RiderSettingsView: View {
    @StateObject var practiceDateViewModel = PracticeDateViewModel()
    @State private var selectedLocation = "North"
    @State private var autoConfirm = true
    @ObservedObject var user = UserDates()

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
                Text("Dates")
                VStack {
                    if !practiceDateViewModel.practiceDates.isEmpty {
                        List(practiceDateViewModel.practiceDates, id: \.self) { date in
                            
                            Toggle(date, isOn: Binding(
                                            get: { user.toggledDates[date] ?? false },
                                            set: { newValue in
                                                user.toggledDates[date] = newValue
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
