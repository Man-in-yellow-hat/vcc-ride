//
//  UserViewModel.swift
//  VccRide
//
//  Created by Nathan King on 10/7/23.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserViewModel: ObservableObject {
    private let databaseRef = Database.database().reference().child("Fall23-Users")
    @Published var users: [String: [String: Any]] = [:]

    func fetchUsers(completion: @escaping () -> Void) {
        print("Fetching users. Shouldn't do this too often..")
        databaseRef.observe(.value) { snapshot in
            if let values = snapshot.value as? [String: [String: Any]] {
                self.users = values
            }
            completion() // Call the completion handler when data is fetched
        }
    }

    
    // Function to filter users based on criteria
    func filterUsers(
        roleFilter: String? = nil,
        activeFilter: String? = nil,
        locationFilter: String? = nil,
        emailSearchFilter: String? = nil
    ) -> [String: [String: Any]] {
        var filteredUsers = users
        
        if let role = roleFilter, roleFilter != "Any" {
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userRole = user["role"] as? String else { return false }
                return userRole == role
            }
        }
        
        if let active = activeFilter, activeFilter != "Any" {
            let activeBool = active == "true"
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userActive = user["active"] as? Bool else { return false }
                return userActive == activeBool
            }
        }
        
        if let location = locationFilter, locationFilter != "Any" {
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userLocation = user["default_location"] as? String else { return false }
                return userLocation == location
            }
        }
        
        if let emailSearch = emailSearchFilter, emailSearchFilter != "" {
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userEmail = user["email"] as? String else { return false }
                return userEmail.localizedStandardContains(emailSearch)
            }
        }
        
        return filteredUsers
    }

}

