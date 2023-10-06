//
//  SettingsView.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            // Other settings content
            Text("SETTINGS")

            Button(action: {
                FirebaseUtil.shared.signOut()
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
