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
    @Published var riderName: String = ""
    @Published var riderLocation: String = ""
    
    init() {
        self.fetchUserFeatures()
    }
    

    func fetchUsers(completion: @escaping () -> Void) {
        print("Fetching users. Shouldn't do this too often..")
        databaseRef.observe(.value) { snapshot in
            if let values = snapshot.value as? [String: [String: Any]] {
                self.users = values
            }
            completion() // Call the completion handler when data is fetched
        }
    }
    
    func fetchUserFeatures() {
        guard let userID = Auth.auth().currentUser?.uid else {
            //TODO: Handle the case when there is no logged-in user
            return
        }
        
        // Firebase reference for the user's data
        let userRef = Database.database().reference().child("Fall23-Users").child(userID)
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                self.riderName = userData["fname"] as? String ?? ""
                self.riderLocation = userData["default_location"] as? String ?? ""
            }
        }
    }
    
    // Function to filter users based on criteria
    func filterUsers(
        roleFilter: String? = nil,
        activeFilter: String? = nil,
        locationFilter: String? = nil
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
        
        return filteredUsers
    }

}

