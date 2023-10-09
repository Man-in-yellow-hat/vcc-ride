//
//  PeopleView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI

struct PeopleView: View {
    @ObservedObject var userViewModel = UserViewModel()
    @State private var selectedRole: String = "Any"
    @State private var selectedLocation: String = "Any"
    @State private var isActive: String = "Any"
    
    @State private var filteredUsers: [String: [String: Any]] = [:]
    @State private var isViewAppeared: Bool = false
    
    var body: some View {
        VStack {
            // Role Picker
            HStack {
                Text("Role:")
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
            ScrollView {
                ForEach(Array(filteredUsers), id: \.key) { (userID, userData) in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email: \(userData["email"] as? String ?? "")")
                        Text("Role: \(userData["role"] as? String ?? "")")
                        Text("Active: \(userData["active"] as? Bool ?? false ? "Yes" : "No")")
                        Text("Location: \(userData["default_location"] as? String ?? "")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment and same size
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
            }
        }
        .onAppear {
            if !isViewAppeared {
                isViewAppeared = true
                userViewModel.fetchUsers {
                    applyFilters() // Apply filters once data is fetched
                    clearFilters()
                }
            }
        }
        .padding()
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


struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
