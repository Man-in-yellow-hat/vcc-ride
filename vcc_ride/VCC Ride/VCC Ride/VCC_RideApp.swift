//
//  VCC_RideApp.swift
//  VCC Ride
//
//  Created by Aman Momin on 10/3/23.
//

import SwiftUI
import SwiftData
import UIKit
import FirebaseCore
import Firebase

extension VCC_RideApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
      }
    }

@main
struct VCC_RideApp: App {
  init() {
    setupAuthentication()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
    
}
