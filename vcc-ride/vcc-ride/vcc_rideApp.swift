//
//  vcc_rideApp.swift
//  vcc-ride
//
//  Created by Aman Momin on 9/21/23.
//

import SwiftUI
import RealmSwift


@main
struct vcc_rideApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//local only realm
class Todo: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var name: String = ""
   @Persisted var status: String = ""
   @Persisted var ownerId: String

   convenience init(name: String, ownerId: String) {
       self.init()
       self.name = name
       self.ownerId = ownerId
   }
}

