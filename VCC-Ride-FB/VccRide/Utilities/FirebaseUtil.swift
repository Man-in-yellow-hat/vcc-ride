//  FirebaseUtil.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import GoogleSignIn
import AuthenticationServices

class FirebaseUtil: NSObject {
    let auth: Auth
    let db: Database
    
    let WHITELISTED: [String] = ["nate.k788@gmail.com", "nathan@algernon.com", "vccride@gmail.com", "vccride.test@gmail.com"]

    static let shared = FirebaseUtil()

    override init() {
        self.auth = Auth.auth()
        self.db = Database.database()
        super.init()
    }

    // Function to check the email domain
    func isEmailInAllowedDomain(_ email: String) -> Bool {
        // Check if the email domain is allowed
        if (WHITELISTED.contains(email)) {
            return true
        }
        return email.hasSuffix("@vanderbilt.edu")
    }
}

class SignIn_withGoogle_VM: ObservableObject {
    @ObservedObject public var viewModel = MainViewModel.shared

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
                                    self.viewModel.handleLoginSuccess(withRole: userRole, userID: user.uid) {
                                        print("Login process completed")
                                    }

                                } else {
                                    completion("User is not active! Please contact an admin.")
                                }
                            } else {
                                completion("Failed to fetch user data.")
                            }
                        } else {
                            
                            let dateRef = databaseRef.child("Fall23-Practices")
                            dateRef.observeSingleEvent(of: .value, with: { snapshot in
                                var dateDict: [String: Bool] = [:]
                                for child in snapshot.children {
                                    if let childSnapshot = child as? DataSnapshot {
                                        // Assuming each key is a date string
                                        dateDict[childSnapshot.key] = false
                                    }
                                }
                                
                                // Now 'dateDict' is populated, proceed with user creation
                                var userData: [String: Any] = [
                                    "email": user.email ?? "",
                                    "role": userRole,
                                    "fname": "",
                                    "lname": "",
                                    "active": false,
                                    "default_location": "",
                                    "default_attendance_confirmation": false,
                                    "attending_dates": dateDict,
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
                                    
                                    self.viewModel.handleLoginSuccess(withRole: userRole, userID: user.uid) {
                                        print("ok")
                                    }
                                    
                                }
                            })
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
    func signInWithApple(credential: AuthCredential, fname: String, lname: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Apple sign-in error: \(error.localizedDescription)")
                completion("Apple sign-in failed, please try again or contact support.")
                return
            }

            guard let user = authResult?.user else {
                completion("Failed to get user data from Apple sign-in.")
                return
            }

            // Get user email
            let userEmail = user.email ?? ""

            let userRole = "JAIL" // Default to a specific role

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
                            self.viewModel.handleLoginSuccess(withRole: userRole, userID: user.uid) {
                                print("Checking active user process completed")
                            }
                        } else {
                            completion("User is not active! Please contact an admin.")
                        }
                    } else {
                        completion("Failed to fetch user data.")
                    }
                } else {
                    let dateRef = databaseRef.child("Fall23-Practices")
                    dateRef.observeSingleEvent(of: .value, with: { snapshot in
                        var dateDict: [String: Bool] = [:]
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot {
                                // Assuming each key is a date string
                                dateDict[childSnapshot.key] = false
                            }
                        }
                    
                    // User data does not exist, create it
                    let newUserData: [String: Any] = [
                        "email": user.email ?? "",
                        "role": userRole,
                        "fname": fname,
                        "lname": lname,
                        "active": false,
                        "default_location": "",
                        "default_attendance_confirmation": false,
                        "attending_dates": dateDict
                    ]
                    
                    print(newUserData)
                    
                    // Set the user data in the Realtime Database
                    userRef.setValue(newUserData) { error, _ in
                        if let error = error {
                            print("Error creating user data: \(error.localizedDescription)")
                            completion("Failed sign-in, please try again or contact support.")
                            return
                        }
                        
                        self.viewModel.setName(first: fname, last: lname)
                        
                        print("User data created successfully in 'Fall23-Users' node in Realtime Database")
                        completion(nil)
                        
                        self.viewModel.handleLoginSuccess(withRole: userRole, userID: user.uid) {
                            print("ok")
                        }
                    }
                })
                }
            }
        }
    }
}

protocol DateFetcher {
    func fetchDates(completion: @escaping ([String]?) -> Void)
}

class FirebaseDateFetcher: DateFetcher {
    func fetchDates(completion: @escaping ([String]?) -> Void) {
        let datesRef = Database.database().reference().child("Fall23-Practices")

        datesRef.observe(.value) { snapshot in
            var fetchedDates: [String] = []

            for child in snapshot.children {
                if let dateSnapshot = child as? DataSnapshot {
                    fetchedDates.append(dateSnapshot.key)
                }
            }
            completion(fetchedDates)
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
    
    private var dateFetcher: DateFetcher
    
    init(dateFetcher: DateFetcher) {
        self.dateFetcher = dateFetcher
    }
    
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
            guard let data = snapshot.value as? [String: Any] else {
                print("Key not found at source location.")
                return
            }

            // Write the key-value pair to the destination location
            destRef.setValue(data) { error, _ in
                if let error = error {
                    print("Error writing to destination: \(error.localizedDescription)")
                    return
                }
                print("Key-value pair duplicated successfully!")

//                sourceRef.removeValue { error, _ in
//                    if let error = error {
//                        print("Error removing key from source: \(error.localizedDescription)")
//                    } else {
//                        print("Key-value pair removed from source location.")
//                    }
//                }
            }
        }

    }
    
    func fetchExistingDates() {
        print("fetching dates")
        dateFetcher.fetchDates { fetchedDates in
            guard var fetchedDates = fetchedDates else { return }

            // Sort the dates chronologically
            fetchedDates.sort { (dateString1, dateString2) in
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMdd" // Update the date format here

                if let date1 = formatter.date(from: dateString1),
                   let date2 = formatter.date(from: dateString2) {
                    return date1 < date2
                }
                return false
            }

            // Update the published property with the new list of dates
            self.practiceDates = fetchedDates
        }
    }

    // Function to add a new practice date
    func addPracticeDate(date: String) {
        // Set the ID of the new date to BE the date
        let practiceDateRef = databaseRef.child("Fall23-Practices").child(date)

        // Create an empty practice date entry
        let practiceDateEntry: [String: Any] = [
            "date": date,
            "has_been_assigned": false,
            "seat_counts": [
                "numNorthOffered": 0,
                "numNorthFilled": 0,
                "numNorthRequested": 0,
                "numRandOffered": 0,
                "numRandFilled": 0,
                "numRandRequested": 0
            ]
        ]

        // Add the new practice date to the database
        practiceDateRef.setValue(practiceDateEntry) { (error, _) in
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
        databaseRef.child("Fall23-Practices").child(date).removeValue { (error, _) in
            if let error = error {
                print("Error deleting practice date: \(error.localizedDescription)")
            } else {
                print("Deleted date successfully!")
            }
        }
    }
}
