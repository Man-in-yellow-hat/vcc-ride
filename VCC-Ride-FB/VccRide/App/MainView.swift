//
//  ContentView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI
import FirebaseDatabase

class MainViewModel: ObservableObject {
    static let shared = MainViewModel()
    @Published var isLoggedIn: Bool = false
    @Published var userRole: String?
    @Published var userID: String?
    @Published var fname: String?
    @Published var lname: String?
    // Handle successful login for any method (Google or Apple)
    func handleLoginSuccess(withRole role: String, userID uid: String, completion: @escaping () -> Void) {
        self.isLoggedIn = true
        self.userRole = role
        self.userID = uid
        
        UserDefaults.standard.set(uid, forKey: "userID") // Generic user ID
        UserDefaults.standard.set(role, forKey: "userRole")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    // Handle sign-out
    func handleSignOut() {
        self.isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userRole")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    
    func getOutOfJail(newRole: String, newLocation: String, newConfirm: Bool, first: String, last: String) {
        let ref = Database.database().reference()
        let userRef = ref.child("Fall23-Users").child(self.userID!)
        
        let updates: [String: Any] = [
            "role": newRole,
            "active": true, // Set "active" to true
            "default_location": newLocation,
            "default_confirm_attendance": newConfirm,
            "fname": first,
            "lname": last
        ]
        
        userRef.updateChildValues(updates) { error, _ in
            if let error = error {
                print("Error updating user's role: \(error.localizedDescription)")
            } else {
                // Role updated successfully
                self.userRole = newRole
                print("User's role updated to \(newRole)")
            }
        }
    }
    
    // get user role from DB
    func fetchUserRole(forUserID userID: String, completion: @escaping () -> Void) {
        print("fetching...", userID)
        let ref = Database.database().reference()
        let userRef = ref.child("Fall23-Users").child(userID) // Adjust the database path as needed
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let role = userData["role"] as? String {
                self.userRole = role
                completion()
            } else {
                print("error fetching role?")
            }
        }
//        print("got role: \(self.userRole ?? "NO ROLE FOUND")")
    }
    
    func setName(first: String, last: String) {
        print("setting names")
        self.fname = first
        self.lname = last
    }
        
    func fetchUserNames(forUserID userID: String, completion: @escaping () -> Void) {
        print("fetching names", userID)
        let ref = Database.database().reference()
        let userRef = ref.child("Fall23-Users").child(userID)
            
        userRef.observeSingleEvent(of: .value) { snapshot in
                if let userData = snapshot.value as? [String: Any],
                   let first = userData["fname"] as? String {
                    self.fname = first
                }
            }
            
        userRef.observeSingleEvent(of: .value) { snapshot in
                if let userData = snapshot.value as? [String: Any],
                   let second = userData["lname"] as? String {
                    self.lname = second
            }
        }
    }
}

struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel.shared

    
    var body: some View {
        Group {
            if viewModel.userRole == nil || !viewModel.isLoggedIn {
                LoginView()
            } else {
                if viewModel.userRole == "JAIL" {
                    SignInJailView()
                } else {
                    ContentView()
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

