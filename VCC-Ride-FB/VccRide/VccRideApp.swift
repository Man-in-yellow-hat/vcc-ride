//
//  FirebaseTestApp.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct FirebaseTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = MainViewModel() // Create an instance of MainViewModel
    
    var body: some Scene {
        WindowGroup {
            // Check if the user is logged in
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            
            // Determine the initial view based on the user's authentication status
            if isLoggedIn {
                MainView()
                    .environmentObject(viewModel)
                    .onAppear {
                      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                          if user != nil {
                              viewModel.isLoggedIn = true
                          } else {
                              print(error!)
                          }
                      }
//                    .onAppear {
//                        FirebaseUtil.shared.authenticateLoggedInUser()
                    }
            } else {
                MainView()
                    .environmentObject(viewModel)
//                        if let savedUserRole = UserDefaults.standard.string(forKey: "userRole") {
//                            // Attempt auto-login with savedUserRole
//                            // Implement Firebase Authentication logic here
//
//                        }
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@available(iOS 9.0, *)
func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
  return GIDSignIn.sharedInstance.handle(url)
}
