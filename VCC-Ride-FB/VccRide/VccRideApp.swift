//
//  FirebaseTestApp.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

@main
struct FirebaseTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var viewModel = MainViewModel.shared
    @State private var isMainViewVisible = false // Add a boolean for the startup screen

    var body: some Scene {
        WindowGroup {
            if self.isMainViewVisible {
                MainView()
            } else {
                StartupScreen()
                    .onAppear() {
                        checkPreviousSignIn()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             withAnimation(.easeInOut(duration: 0.5)) {
                                 self.isMainViewVisible = true
                             }
                        }
                    }
            }
        }
    }

    private func checkPreviousSignIn() {
        // Check for Google Sign-In
        if GIDSignIn.sharedInstance.hasPreviousSignIn() && GIDSignIn.sharedInstance.currentUser == nil {
            GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
                handleSignIn(user: Auth.auth().currentUser, error: error)
            }
        }
        // Check for Apple Sign-In
        else if let appleID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey"), Auth.auth().currentUser == nil {
            let appleIDProvider = OAuthProvider(providerID: "apple.com")
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: appleID, rawNonce: nil)
            Auth.auth().signIn(with: credential) { authResult, error in
                handleSignIn(user: authResult?.user, error: error)
            }
        }
    }

    private func handleSignIn(user: User?, error: Error?) {
        if let user = user {
            print(user.uid)
            viewModel.isLoggedIn = true
            viewModel.userID = user.uid
            viewModel.fetchUserRole(forUserID: user.uid)
            viewModel.fetchUserNames(forUserID: user.uid) {
                print("finished getting name")
            }
        } else {
            print(error ?? "Unknown error during sign-in")
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
