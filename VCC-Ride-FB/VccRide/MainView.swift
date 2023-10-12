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
        UserDefaults.standard.set(uid, forKey: "googleUserID")
        UserDefaults.standard.set(role, forKey: "userRole")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        print(self.userRole)
    }
    
    func handleSignOut() {
        self.isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    func printstuff() {
        print("printing: ", self.isLoggedIn, self.userID, self.userRole)
    }
    
    // get user role from DB
    func fetchUserRole(forUserID userID: String) {
        print("fetching...")
        let ref = Database.database().reference()
        let userRef = ref.child("Fall23-Users").child(userID) // Adjust the database path as needed

        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let role = userData["role"] as? String {
                self.userRole = role
            }
        }
        print(self.userRole)
    }

    // Add a method to retrieve the user's role from UserDefaults
//    func retrieveUserRole() {
//        self.userRole = UserDefaults.standard.string(forKey: "userRole")
//    }
    
}

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                if let userRole = viewModel.userRole {
                    if userRole == "JAIL" {
                        // Redirect to SignInJailView if the role is "JAIL"
//                        print("JAIL")
                        SignInJailView().environmentObject(viewModel)
                    } else {
                        // Navigate to the main content view based on the user's role
//                        print("Content")
                        ContentView().environmentObject(viewModel)
                    }
                }
            } else {
//                print("trying to go to login view?")
                LoginView().environmentObject(viewModel)
            }
        }
//        .onAppear {
//            viewModel.retrieveUserRole()
//        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
    }
}

