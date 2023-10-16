//
//  SettingsView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            // Other settings content
            Text("SETTINGS")

            Button(action: {
                signOut()
            }) {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.red) // Button background color
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded rectangle shape with corner radius
        }
    }
    
    func signOut() {
        do {
            try FirebaseUtil.shared.auth.signOut()
            print("signed out?")
            self.viewModel.handleSignOut()
            // Clear user-related data from UserDefaults or perform any additional cleanup
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView()
    }
}
