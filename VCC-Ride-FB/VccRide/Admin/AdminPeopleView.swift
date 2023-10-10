//
//  PeopleView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI
import FirebaseDatabase

struct EditUserView: View {
    var userID: String
    @State var userData: [String: Any]

    var body: some View {
        Text("Email: \(userData["email"] as? String ?? "")")
        Form {
            ForEach(userData.sorted(by: { $0.key < $1.key }), id: \.key) { (key, value) in
                if key != "email" {
                    Section(header: Text(key.capitalized)) {
                        if let stringValue = value as? String {
                            TextField("Enter \(key.capitalized)", text: Binding<String>(
                                get: { stringValue },
                                set: { newValue in
                                    userData[key] = newValue
                                }
                            ))
                        } else if let boolValue = value as? Bool {
                            Toggle(isOn: Binding<Bool>(
                                get: { boolValue },
                                set: { newValue in
                                    userData[key] = newValue
                                }
                            )) {
                                Text(key.capitalized)
                            }
                        } else {
                            Text("Unsupported data type for \(key)")
                        }
                    }
                }
            }

            Button("Save Changes") {
                updateUserData()
            }
        }
        .navigationBarTitle("Edit User")
    }

    private func updateUserData() {
        // Get a reference to the Firebase Realtime Database
        let ref = Database.database().reference()

        // Update the user's data in the database
        ref.child("Fall23-Users").child(userID).updateChildValues(userData) { error, _ in
            if let error = error {
                print("Error updating user data: \(error.localizedDescription)")
            } else {
                print("User data updated successfully")
            }
        }
    }
}


struct AdminPeopleView: View {
    @ObservedObject var userViewModel = UserViewModel()
    @State private var selectedRole: String = "Any"
    @State private var selectedLocation: String = "Any"
    @State private var isActive: String = "Any"

    @State private var filteredUsers: [String: [String: Any]] = [:]
    @State private var isViewAppeared: Bool = false

    @State private var isEditUserViewPresented = false // Track whether EditUserView is presented
    @State private var selectedUserID = "" // Store the selected user's ID

    var body: some View {
        NavigationView {
            VStack {
                // Role Picker
                HStack {
                    Text("Role:")
                        .padding()
                    Spacer()
                    Picker("", selection: $selectedRole) {
                        Text("Any").tag("Any")
                        Text("Rider").tag("rider")
                        Text("Driver").tag("driver")
                        Text("Admin").tag("admin")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedRole) { _ in
                        applyFilters()
                    }
                }
                
                // Location Picker
                HStack {
                    Text("Location:")
                        .padding()
                    Spacer()
                    Picker("", selection: $selectedLocation) {
                        Text("Any").tag("Any")
                        Text("North").tag("North")
                        Text("Rand").tag("Rand")
                        Text("No Preference").tag("no_pref")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedLocation) { _ in
                        applyFilters()
                    }
                }
                
                // Active Picker
                HStack {
                    Text("Active:")
                        .padding()
                    Spacer()
                    Picker("", selection: $isActive) {
                        Text("Any").tag("Any")
                        Text("Active").tag("true")
                        Text("Inactive").tag("false")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: isActive) { _ in
                        applyFilters()
                    }
                }

                // Clear Filters Button
                Button("Clear Filters") {
                    clearFilters()
                }

                // User List
                List {
                    ForEach(Array(filteredUsers), id: \.key) { (userID, userData) in
                        Button(action: {
                            // Show EditUserView when a user is selected
                            selectedUserID = userID
                            isEditUserViewPresented.toggle()
                        }) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Email: \(userData["email"] as? String ?? "")")
                                Text("Role: \(userData["role"] as? String ?? "")")
                                Text("Active: \(userData["active"] as? Bool ?? false ? "Yes" : "No")")
                                Text("Location: \(userData["default_location"] as? String ?? "")")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .sheet(isPresented: $isEditUserViewPresented) {
                EditUserView(userID: selectedUserID, userData: filteredUsers[selectedUserID] ?? [:])
            }
            .navigationBarTitle("Admin People") // Adjust the title as needed
        }
        .onAppear {
            if !isViewAppeared {
                isViewAppeared = true
                userViewModel.fetchUsers {
                    applyFilters()
                    clearFilters()
                }
            }
        }
    }

    private func applyFilters() {
        filteredUsers = userViewModel.filterUsers(
            roleFilter: selectedRole,
            activeFilter: isActive,
            locationFilter: selectedLocation
        )
    }

    private func clearFilters() {
        selectedRole = "Any"
        selectedLocation = "Any"
        isActive = "Any"
        applyFilters()
    }
}

struct AdminPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        AdminPeopleView()
    }
}
