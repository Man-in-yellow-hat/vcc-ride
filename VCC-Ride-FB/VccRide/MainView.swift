//
//  ContentView.swift
//  FirebaseTest
//
//  Created by Junwon Lee on 10/4/23.
//

import SwiftUI

class MainViewModel: ObservableObject {
//    @State var isLoggedIn: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var userRole: String? // Add the role field

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
    
    // Add a method to retrieve the user's role from UserDefaults
    func retrieveUserRole() {
        self.userRole = UserDefaults.standard.string(forKey: "userRole")
    }
    
}

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        Group {
            if viewModel.isLoggedIn {
                ContentView().environmentObject(viewModel)
            } else {
                LoginView().environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.retrieveUserRole()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
    }
}

