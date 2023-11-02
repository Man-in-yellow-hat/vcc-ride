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
        if (email == "nate.k788@gmail.com" || email == "nathan@algernon.com") {
            return true
        }
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
                    let userRole = "JAIL" // Default to rider
                    
                    // Create a reference to your Realtime Database
                    let databaseRef = Database.database().reference()

                    // Check if the user's data already exists
                    let userRef = databaseRef.child("Fall23-Users").child(user.uid)
                    userRef.observeSingleEvent(of: .value) { snapshot in
                        if snapshot.exists() {
                            // User data already exists, fetch the userRole from the database
                            if let userData = snapshot.value as? [String: Any],
                               let userRole = userData["role"] as? String {
                                if userData["active"] is Bool {
                                    completion(nil)
                                    self.viewModel?.handleLoginSuccess(withRole: userRole, userID: user.uid)
                                } else {
                                    completion("User is not active! Please contact an admin.")
                                }
                            } else {
                                completion("Failed to fetch user data.")
                            }
                        } else {
                            // User data does not exist, create it
                            var userData: [String: Any] = [:]
                            userData = [
                                "email": user.email ?? "",
                                "role": userRole,
                                "fname": "",
                                "lname": "",
                                "active": false,
                                "default_location": "",
                                "default_attendance_confirmation": false
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

    // Published property to hold the list of dates
    @Published var practiceDates: [String] = []

    // Published property to hold unique ID for date data
    @Published var dateID: [String: String] = [:]
    
    func transferPracticeDates() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd"
        
        let curDate = dateFormatter.string(from: today)
        print(curDate)
        let sourceRef = databaseRef.child("Fall23-Practices").child(curDate)
        let destRef = databaseRef.child("Daily-Practice")
        
        sourceRef.observeSingleEvent(of: .value) { snapshot in
            // Check if the key exists at the source location
            guard let value = snapshot.value else {
                print("Key not found at source location.")
                return
            }

            // Write the key-value pair to the destination location
            destRef.setValue(value) { error, _ in
                if let error = error {
                    print("Error writing to destination: \(error.localizedDescription)")
                    return
                }

                print("Key-value pair moved successfully!")

                sourceRef.removeValue { error, _ in
                    if let error = error {
                        print("Error removing key from source: \(error.localizedDescription)")
                    } else {
                        print("Key-value pair removed from source location.")
                    }
                }
            }
        }

    }
    


    func fetchExistingDates() {
        print("fetching dates")
        let datesRef = databaseRef.child("Fall23-Practices")

        datesRef.observe(.value) { snapshot in
            var fetchedDates: [String] = []

            for child in snapshot.children {
                if let dateSnapshot = child as? DataSnapshot {
                    if let date = dateSnapshot.childSnapshot(forPath: "date").value as? String {
//                        print("date: ", date)
                        fetchedDates.append(date)
                        self.dateID[date] = dateSnapshot.key
                    }
                }
            }
            fetchedDates.sort()

            // Update the published property with the new list of dates
            self.practiceDates = fetchedDates
        }
    }

    // Function to add a new practice date
    func addPracticeDate(date: String) {


        // Generate a unique ID for the new practice date
        let practiceDateID = databaseRef.child("Fall23-Practices").childByAutoId().key ?? ""

        // Create an empty practice date entry
        let practiceDateEntry: [String: Any] = [
            "date": date
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

    //Function to delete practice date
    func deletePracticeDate(date: String) {
        // Delete practice date from database
        databaseRef.child("Fall23-Practices").child(self.dateID[date]!).removeValue { (error, _) in
            if let error = error {
                print("Error deleting practice date: \(error.localizedDescription)")
            } else {
                print("Deleted date successfully!")
            }
        }
    }
}
