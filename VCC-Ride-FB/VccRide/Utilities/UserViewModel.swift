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

    func fetchUsers() {
        print("FETCHING! Should not do this too often..")
        databaseRef.observe(.value) { snapshot in
            if let values = snapshot.value as? [String: [String: Any]] {
                self.users = values
            }
        }
    }
    
    // Function to filter users based on criteria
    func filterUsers(
        role: String? = nil,
        active: Bool? = nil,
        location: String? = nil
    ) -> [String: [String: Any]] {
        var filteredUsers = users
        
        if let role = role {
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userRole = user["role"] as? String else { return false }
                return userRole == role
            }
        }
        
        if let active = active {
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userActive = user["active"] as? Bool else { return false }
                return userActive == active
            }
        }
        
        if let location = location {
            filteredUsers = filteredUsers.filter { (_, user) in
                guard let userLocation = user["default_location"] as? String else { return false }
                return userLocation == location
            }
        }
        
        return filteredUsers
    }

}

