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
//    @StateObject var viewModel = MainViewModel() // Create an instance of MainViewModel
    @ObservedObject private var viewModel = MainViewModel.shared
    @State private var isMainViewVisible = false // Add a boolean for the startup screen

    var body: some Scene {
        WindowGroup {
            if self.isMainViewVisible {
                MainView()
            } else {
                StartupScreen()
                    .onAppear() {
                        if(GIDSignIn.sharedInstance.hasPreviousSignIn() && GIDSignIn.sharedInstance.currentUser == nil) {
                            GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             withAnimation(.easeInOut(duration: 0.5)) {
                                 self.isMainViewVisible = true
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
