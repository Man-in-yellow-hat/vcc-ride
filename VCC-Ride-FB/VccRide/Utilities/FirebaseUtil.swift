//  FirebaseUtil.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import Foundation
import SwiftUI
import Firebase
//import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn

class FirebaseUtil: NSObject {
    let auth: Auth
    let db: Database
    var viewModel: MainViewModel?
    
    static let shared = FirebaseUtil()
    
    override init() {
        self.auth = Auth.auth()
        self.db = Database.database()
//        self.storage = Storage.storage()
        super.init()
    }
    
    // Function to check the email domain
    func isEmailInAllowedDomain(_ email: String) -> Bool {
        // Check if the email domain is allowed
        return email.hasSuffix("@vanderbilt.edu")
    }
    
//    func authenticateLoggedInUser() {
//        if UserDefaults.standard.bool(forKey: "isLoggedIn"),
//           let googleUserID = UserDefaults.standard.string(forKey: "googleUserID") {
//            // You can use the saved Google User ID for Firebase Authentication
//            Auth.auth().signIn(withCustomToken: googleUserID) { authResult, error in
//                if let error = error {
//                    // Handle authentication error
//                    print("Authentication failed: \(error.localizedDescription)")
//                } else if authResult != nil {
//                    // Authentication successful
//                    print("Authentication successful")
//                    
//                    // Proceed with other initialization or data retrieval logic here
//                }
//            }
//        }
//    }
}

class SignIn_withGoogle_VM: ObservableObject {
    var viewModel: MainViewModel?
    
    func signInWithGoogle(completion: @escaping (String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                // Handle generic sign-in error
                print(error.localizedDescription)
                completion("Failed sign-in, please try again or contact support.")
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else {return}
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString)
            
            // Get the user's email
            let userEmail = user.profile?.email ?? ""
            
            // Check if the email domain is allowed
            if FirebaseUtil.shared.isEmailInAllowedDomain(userEmail) {
                // Email domain is allowed, proceed with sign-in
                Auth.auth().signIn(with: credential) {res, error in
                    if let error = error {
                        // Handle sign-in error specific to allowed domain
                        print(error.localizedDescription)
                        completion("Please log in with a vanderbilt.edu email!")
                        return
                    }
                    
                    guard let user = res?.user else {return}
                    print(user)
//                    self.loginSucceeded = true
                    let userRole = "rider" // Default to rider
                    
                    // Create a reference to your Realtime Database
                    let databaseRef = Database.database().reference()

                    // Check if the user's data already exists
                    let userRef = databaseRef.child("Fall23-Users").child(user.uid)
                    userRef.observeSingleEvent(of: .value) { snapshot in
                        if snapshot.exists() {
                            // User data already exists, fetch the userRole from the database
                            if let userData = snapshot.value as? [String: Any],
                               let userRole = userData["role"] as? String {
                                completion(nil)
                                self.viewModel?.handleLoginSuccess(withRole: userRole, userID: user.uid)
                            } else {
                                completion("Failed to fetch user data.")
                            }
                        } else {
                            // User data does not exist, create it
                            let userData: [String: Any] = [
                                "email": user.email ?? "",
                                "role": userRole
                                // You can add more user data fields here
                            ]

                            // Set the user data in the Realtime Database under the "Fall23-Users" node using the user's UID as the key
                            userRef.setValue(userData) { error, _ in
                                if let error = error {
                                    print("Error creating user data: \(error.localizedDescription)")
                                    completion("Failed sign-in, please try again or contact support.")
                                    return
                                }

                                print("User data created successfully in 'Fall23-Users' node in Realtime Database")
                                completion(nil)
                                
                                self.viewModel?.handleLoginSuccess(withRole: userRole, userID: user.uid)
                            }
                        }
                    }
                }
            } else {
                // Email domain is not allowed, show an error or take appropriate action
                print("User signed in with disallowed domain: \(userEmail)")
                completion("Please log in with a valid @vanderbilt.edu email!")
            }
        }
    }
}


class PracticeDateViewModel: ObservableObject {
    // Reference to the Firebase Realtime Database
    let databaseRef = Database.database().reference()
    
    func fetchExistingDates(completion: @escaping ([String]) -> Void) {
        print("fetching dates")
        let datesRef = databaseRef.child("Fall23-Practices")
        
        datesRef.observe(.value) { snapshot in
            var fetchedDates: [String] = []
            
            for child in snapshot.children {
                if let dateSnapshot = child as? DataSnapshot {
                    if let date = dateSnapshot.childSnapshot(forPath: "date").value as? String {
                        print("date: ", date)
                        fetchedDates.append(date)
                    }
                }
            }
            
            completion(fetchedDates)
        }
    }
    
    // Function to add a new practice date
    func addPracticeDate(date: String) {
        // Generate a unique ID for the new practice date
        let practiceDateID = databaseRef.child("Fall23-Practices").childByAutoId().key ?? ""
        
        let emptyDict: [String: Int] = [:]
        
        // Create an empty practice date entry
        let practiceDateEntry: [String: Any] = [
            "date": date,
            "north_drivers": emptyDict,
            "north_riders": emptyDict,
            "rand_drivers": emptyDict,
            "rand_riders": emptyDict,
            "no_pref_drivers": emptyDict
        ]
        
        // Add the new practice date to the database
        databaseRef.child("Fall23-Practices").child(practiceDateID).setValue(practiceDateEntry) { (error, _) in
            if let error = error {
                print("Error adding practice date: \(error.localizedDescription)")
            } else {
                print("Practice date added successfully!")
            }
        }
    }
}




////
////  FirebaseUtil.swift
////  FirebaseTest
////
////  Created by Junwon Lee on 10/4/23.
////
//
//import Foundation
//import SwiftUI
//import Firebase
////import FirebaseStorage
//import FirebaseDatabase
//import GoogleSignIn
//
//class FirebaseUtil: NSObject {
//    let auth: Auth
////    let storage: Storage
////    let firestore: Firestore
//    let db: Database
//
//    static let shared = FirebaseUtil()
//
//    override init() {
////        FirebaseApp.configure()
//
//        self.auth = Auth.auth()
//        self.db = Database.database()
////        self.storage = Storage.storage()
////        self.firestore = Firestore.firestore()
//
//        super.init()
//    }
//
//    // Function to check the email domain
//    func isEmailInAllowedDomain(_ email: String) -> Bool {
//        // Check if the email domain is allowed
//        return email.hasSuffix("@vanderbilt.edu")
//    }
//}
//
//class SignIn_withGoogle_VM: ObservableObject {
////    @Published var loginSucceeded = false
//    var viewModel: MainViewModel?
//
//    func signInWithGoogle(completion: @escaping (Bool, String?, String?) -> Void) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
//
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
//            if let error = error {
//                // Handle generic sign-in error
//                print(error.localizedDescription)
//                completion(false, "Failed sign-in, please try again or contact support.", nil)
//                return
//            }
//
//            guard
//                let user = user?.user,
//                let idToken = user.idToken else {return}
//
//            let accessToken = user.accessToken
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
//                accessToken: accessToken.tokenString)
//
//            // Get the user's email
//            let userEmail = user.profile?.email ?? ""
//
//            // Check if the email domain is allowed
//            if FirebaseUtil.shared.isEmailInAllowedDomain(userEmail) {
//                // Email domain is allowed, proceed with sign-in
//                Auth.auth().signIn(with: credential) {res, error in
//                    if let error = error {
//                        // Handle sign-in error specific to allowed domain
//                        print(error.localizedDescription)
//                        completion(false, "Please log in with a vanderbilt.edu email!", nil)
//                        return
//                    }
//
//                    guard let user = res?.user else {return}
//                    print(user)
////                    self.loginSucceeded = true
//                    let userRole = "rider" // Default to rider
//
//                    // Save the user's role to UserDefaults
//                    self.viewModel?.userRole = userRole
//                    self.viewModel?.saveUserRole()
//
//                    // Create a reference to your Realtime Database
//                    let databaseRef = Database.database().reference()
//
//                    // Check if the user's data already exists
//                    let userRef = databaseRef.child("Fall23-Users").child(user.uid)
//                    userRef.observeSingleEvent(of: .value) { snapshot in
//                        if snapshot.exists() {
//                            // User data already exists, fetch the userRole from the database
//                            if let userData = snapshot.value as? [String: Any],
//                               let userRole = userData["role"] as? String {
//                                completion(true, nil, userRole)
//                            } else {
//                                completion(false, "Failed to fetch user data.", nil)
//                            }
//                        } else {
//                            // User data does not exist, create it
//                            let userData: [String: Any] = [
//                                "email": user.email ?? "",
//                                "role": userRole
//                                // You can add more user data fields here
//                            ]
//
//                            // Set the user data in the Realtime Database under the "Fall23-Users" node using the user's UID as the key
//                            userRef.setValue(userData) { error, _ in
//                                if let error = error {
//                                    print("Error creating user data: \(error.localizedDescription)")
//                                    completion(false, "Failed sign-in, please try again or contact support.", nil)
//                                    return
//                                }
//
//                                print("User data created successfully in 'Fall23-Users' node in Realtime Database")
//                                completion(true, nil, userRole)
//                            }
//                        }
//                    }
//                }
//            } else {
//                // Email domain is not allowed, show an error or take appropriate action
//                print("User signed in with disallowed domain: \(userEmail)")
//                completion(false, "Please log in with a valid @vanderbilt.edu email!", nil)
//                // Show an error message or take appropriate action
//            }
//        }
//    }
//}
//










