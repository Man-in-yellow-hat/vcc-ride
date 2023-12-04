//
//  SignInJailView.swift
//  VccRide
//
//  Created by Nathan King on 10/11/23.
//

import SwiftUI
import Firebase

struct SignInJailView: View {
    @ObservedObject private var viewModel = MainViewModel.shared

    @State private var selectedConfirm: Bool = false

    @State var selectedRole: String = "rider"
    @State private var selectedLocation: String = "North"
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    

    var body: some View {
        ScrollView {
            VStack {
                Text("Sign Up")
                    .font(.title)


                VStack {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .scrollDismissesKeyboard(.immediately)



                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .scrollDismissesKeyboard(.immediately)

                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                Group {
                    VStack(spacing: 10) {
                        Text("Please fill out the form below to sign up!")
                            .font(.subheadline)
                            .padding()
                        
                        Text("Select your Role.")
                            .font(.subheadline)
                    }
                    
                    
                    Picker("Role", selection: $selectedRole) {
                        Text("Rider").tag("rider")
                        Text("Driver").tag("driver")
//                        Text("Admin").tag("admin") // TODO: remove? this is for apple release
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedRole) { newValue in
                        // Reset location to "Rand" when switching from "Driver" to "Rider" or vice versa
                        if selectedLocation == "No Preference" {
                            selectedLocation = "Rand"
                        }
                    }
                    
                    Text("Select Default Location")
                        .font(.subheadline)
                    
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
                    
                    Text("Daily form or automatic attendance?")
                        .font(.subheadline)

                    // Attendance Confirmation Picker (Available for all)
                    Picker("Attendance Confirmation", selection: $selectedConfirm) {
                        Text("Form").tag(false)
                        Text("Automatic").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                
                ZStack {
                    Button(action: {
                        // Save the selected role to the database
                        viewModel.getOutOfJail(newRole: selectedRole, newLocation: selectedLocation, newConfirm: selectedConfirm, first: firstName, last: lastName)
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .padding(.top, 20)

                ZStack {
                    Button(action: {
                        // Sign out the user
                        do {
                            try Auth.auth().signOut()
                            viewModel.handleSignOut() // Handle sign out in the main view model
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color.red)
                    .cornerRadius(10)
                }
                .padding(.top, 10)
                
                Text("Note: If you wish to be an Admin, please contact your Transportation Director.")
                    .padding(.top, 60)
                    .font(.footnote)
            }
            .padding() // Add margins to the entire content
            .onAppear {
                // Initialize firstName and lastName with values from viewModel
                firstName = viewModel.fname ?? ""
                lastName = viewModel.lname ?? ""
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
}


struct SignInJailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInJailView()
    }
}

