//
//  SignInJailView.swift
//  VccRide
//
//  Created by Nathan King on 10/11/23.
//

import SwiftUI
import Firebase

struct SignInJailView: View {
    @EnvironmentObject var viewModel: MainViewModel
    @State var selectedRole: String = "rider"
    
    @State private var selectedLocation: String = "North"
    
    @State private var selectedConfirm: Bool = false


    var body: some View {
        VStack {
            Text("Please select your role default preferences")
                .font(.title)
                .padding()
            
            Text("Select your Role. If you wish to be an admin, please contact your transportation director.")
                        .padding(.top) // Add spacing above this label

            Picker("Role", selection: $selectedRole) {
                Text("Rider").tag("rider")
                Text("Driver").tag("driver")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Select Default Location")
                        .padding(.top) // Add spacing above this label
            
            if selectedRole == "driver" {
                Picker("Default Location", selection: $selectedLocation) {
                    Text("North").tag("North")
                    Text("Rand").tag("Rand")
                    Text("No Preference").tag("No Preference")
                }
                .pickerStyle(SegmentedPickerStyle())
            } else {
                Picker("Default Location", selection: $selectedLocation) {
                    Text("North").tag("North")
                    Text("Rand").tag("Rand")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Text("Do you want to be automatically confirmed for attendance or fill out a form?")
                       .padding(.top)

            // Attendance Confirmation Picker (Available for all)
            Picker("Attendance Confirmation", selection: $selectedConfirm) {
                Text("Form").tag(false)
                Text("Automatic").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())

            Button("Continue") {
                // Save the selected role to the database
                viewModel.getOutOfJail(newRole: selectedRole, newLocation: selectedLocation, newConfirm: selectedConfirm)
            }

            Button("Sign Out") {
                // Sign out the user
                do {
                    try Auth.auth().signOut()
                    viewModel.handleSignOut() // Handle sign out in the main view model
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }
        }
    }
}


struct SignInJailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInJailView()
    }
}
