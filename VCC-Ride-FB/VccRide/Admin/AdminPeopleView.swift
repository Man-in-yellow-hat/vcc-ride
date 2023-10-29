//
//  AdminPeopleView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI
import FirebaseDatabase

struct EditUserView: View {
    @Binding var userID: String
    @Binding var userData: [String: Any]

    @State private var email: String = ""
    @State private var role: String = ""
    @State private var active: Bool = false
    @State private var defaultLocation: String = ""
    @State private var seats = 4
    
    @State private var confirmRoleChange: Bool = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Email: \(email)")
                .font(.headline)
                .padding()

            Form {
                Section(header: Text("Role")) {
                    Picker("Select Role", selection: $role) {
                        Text("Rider").tag("rider")
                        Text("Driver").tag("driver")
                        Text("Admin").tag("admin")
                    }
                }

                Section(header: Text("Active")) {
                    Toggle("Active", isOn: $active)
                }

                Section(header: Text("Default Location")) {
                    Picker("Select Location", selection: $defaultLocation) {
                        Text("North").tag("North")
                        Text("Rand").tag("Rand")
                        if role != "rider" {
                            Text("No Preference").tag("no_pref")
                        }
                    }
                }
                if role != "rider" {
                    Section(header: Text("Number of Seats")) {
                        Stepper(value: $seats, in: 0...10) {
                            Text("Seats: \(seats)")
                        }
                    }
                }
            }
            if confirmRoleChange {
                Section {
                    Text("Changing a user to or from an admin role requires confirmation.")
                    Button("Confirm Role Change") {
                        // Update the user's role
                        userData["role"] = role
                        // Save user data in the database
                        updateUserData(userData: userData, userID: userID)
                        // Dismiss the view
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                Button("Save") {
                    if role != userData["role"] as? String && role == "admin" || userData["role"] as! String == "admin" {
                        // A role change is requested, show the confirmation dialog
                        confirmRoleChange = true
                    } else {
                        // Role is not changing, proceed to save
                        // Update the userData dictionary with the changes
                        userData["role"] = role
                        userData["active"] = active
                        userData["default_location"] = defaultLocation
                        userData["default_seats"] = seats

                        // Save user data in the database
                        updateUserData(userData: userData, userID: userID)

                        // Dismiss the view
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationBarTitle("Edit User")
        .onAppear {
            email = userData["email"] as? String ?? ""
            role = userData["role"] as? String ?? ""
            active = userData["active"] as? Bool ?? false
            defaultLocation = userData["default_location"] as? String ?? ""
            seats = userData["default_seats"] as? Int ?? 4
        }
    }
    private func updateUserData(userData: [String: Any], userID: String) {
        print("user:", userID)
        // Get a reference to the Firebase Realtime Database
        let ref = Database.database().reference()
        print(userID)

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

    @State private var isEditUserViewPresented = false
    @State private var selectedUserID = ""
    @State private var selectedUserData: [String: Any] = [:]

    var body: some View {
        NavigationStack {
            VStack (spacing: -10) {
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

                HStack {
                    Text("Location:")
                        .padding()
                    Spacer()
                    Picker("", selection: $selectedLocation) {
                        Text("Any").tag("Any")
                        Text("North").tag("North")
                        Text("Rand").tag("Rand")
                        Text("No Preference").tag("No Preference")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedLocation) { _ in
                        applyFilters()
                    }
                }

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

                Button("Clear Filters") {
                    clearFilters()
                }
                .padding()

                List {
                    ForEach(Array(filteredUsers), id: \.key) { (userID, userData) in
                        Button(action: {
                            selectedUserID = userID
                            selectedUserData = userData
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
                EditUserView(userID: $selectedUserID, userData: $selectedUserData)
            }
            .navigationBarTitle("Admin People")
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
