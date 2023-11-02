////
////  DayOfPractice.swift
////  VccRide
////
////  Created by Nathan King on 10/29/23.
////
//
//import Foundation
//import FirebaseDatabase
//
//
//func saveDriverAttendance() {
//    let databaseRef = Database.database().reference()
//    let dateRef = databaseRef.child("Daily-Practice").child(date)
//    let statsRef = databaseRef.child("Fall23-Stats")
//
//    // Observe the "daily_practice" node for the current date
//    dateRef.observeSingleEvent(of: .value, with: { snapshot in
//        // Check if "north_driver" and "rand_driver" exist
//        if snapshot.hasChild("north_driver") && snapshot.hasChild("rand_driver") {
//            let northDriverRef = dateRef.child("north_driver")
//            let randDriverRef = dateRef.child("rand_driver")
//
//            // Get the list of drivers under "north_driver" and "rand_driver"
//            let northDrivers = northDriverRef.children.allObjects as! [DataSnapshot]
//            let randDrivers = randDriverRef.children.allObjects as! [DataSnapshot]
//
//            // Combine all driver names
//            let allDrivers = northDrivers.map { $0.key } + randDrivers.map { $0.key }
//
//            // Loop through each driver
//            for driver in allDrivers {
//                // Update the corresponding entry in "Fall23-Stats"
//                statsRef.observeSingleEvent(of: .value, with: { statsSnapshot in
//                    if statsSnapshot.hasChild(driver) {
//                        // If the driver exists, increment their value
//                        if let existingValue = statsSnapshot.childSnapshot(forPath: driver).value as? Int {
//                            statsRef.child(driver).setValue(existingValue + 1)
//                        }
//                    } else {
//                        // If the driver doesn't exist, add them and initialize to 1
//                        statsRef.child(driver).setValue(1)
//                    }
//                }) { error in
//                    print("Error fetching data: \(error.localizedDescription)")
//                }
//            }
//        }
//    }) { error in
//        print("Error fetching data: \(error.localizedDescription)")
//    }
//}
