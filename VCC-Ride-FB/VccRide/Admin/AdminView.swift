//
//  AdminDash.swift
//  FirebaseTest
//
//  Created by Nathan King on 10/6/23.
//

import SwiftUI

struct AdminView: View {
    @State private var assignDrivers = AssignDrivers() // Create an instance of AssignDrivers
    
    var body: some View {
        VStack {
            Text("ADMIN!")
            Button("ASSIGN DRIVERS PLEASE") {
                assignDrivers.assignNoPrefDrivers()
            }
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}

