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
            MainView()
                .environmentObject(viewModel)
                .onAppear() {
                    if(GIDSignIn.sharedInstance.hasPreviousSignIn() && GIDSignIn.sharedInstance.currentUser == nil) {
                        GIDSignIn.sharedInstance.restorePreviousSignIn() {
                            user, error in
                            if let user = Auth.auth().currentUser {
                                print(user.uid)
                                viewModel.isLoggedIn = true
                                viewModel.userID = user.uid
                                viewModel.fetchUserRole(forUserID: user.uid)
                            } else {
                                print(error ?? "unknown error")
                            }
                        }
                    }
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
