//
//  ContentView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI
import FirebaseDatabase

class MainViewModel: ObservableObject {
//    @State var isLoggedIn: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var userRole: String? // Add the role field
    @Published var userID: String?

    func handleLoginSuccess(withRole role: String, userID uid: String) {
        self.isLoggedIn = true
        self.userRole = role
        self.userID = uid
        UserDefaults.standard.set(uid, forKey: "googleUserID")
        UserDefaults.standard.set(role, forKey: "userRole")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
//        print(self.userRole)
    }
    
    func handleSignOut() {
        self.isLoggedIn = false
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
    func fetchUserRole(forUserID userID: String) {
        print("fetching...", userID)
        let ref = Database.database().reference()
        let userRef = ref.child("Fall23-Users").child(userID) // Adjust the database path as needed

        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let role = userData["role"] as? String {
                self.userRole = role
                print("role: ", self.userRole)
            }
        }
    }
}

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        Group {
            if viewModel.userRole == nil || !viewModel.isLoggedIn {
                LoginView().environmentObject(viewModel)
            } else {
                if viewModel.userRole == "JAIL" {
                    SignInJailView().environmentObject(viewModel)
                } else {
                    ContentView().environmentObject(viewModel)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
    }
}

