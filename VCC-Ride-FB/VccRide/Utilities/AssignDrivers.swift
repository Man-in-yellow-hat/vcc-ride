//
//  AssignNoPrefs.swift
//  VccRide
//
//  Created by Nathan King on 10/16/23.
//

import SwiftUI
import Firebase

class AssignDrivers {
    private var randDrivers = [String:Int]()
    private var numRandSeats = 0
    private var northDrivers = [String:Int]()
    private var numNorthSeats = 0
    private var noPrefDrivers = [String:Int]()
    
    private var randRiders = [String:Int]()
    private var numRandRiders = 0
    
    private var northRiders = [String:Int]()
    private var numNorthRiders = 0
    
    private var date = ""
    
    private func getDate() {
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd"
        self.date = dateFormatter.string(from: today)
        
        print("Today's date: \(self.date)")
    }
    
    
    public func getLists() {
        self.date = "Oct10"
        let practiceRef = Database.database().reference().child("Fall23-Practices").child(self.date)
        
        practiceRef.observeSingleEvent(of: .value) { snapshot in
            if let riderData = snapshot.value as? [String: Any] {
                // Assign data from Firebase to the instance variables
                self.randDrivers = riderData["rand_driver"] as? [String: Int] ?? [String: Int]()
                self.northDrivers = riderData["north_driver"] as? [String: Int] ?? [String: Int]()
                self.noPrefDrivers = riderData["no_pref_driver"] as? [String: Int] ?? [String: Int]()
                self.northRiders = riderData["north_rider"] as? [String: Int] ?? [String: Int]()
                self.randRiders = riderData["rand_rider"] as? [String: Int] ?? [String: Int]()
            }
        }
    }
    
    
    public func assignNoPrefDrivers() {
        getLists()
        self.date = "Oct10" // TODO: FIX HARDCODED
        self.numRandRiders = randRiders.values.reduce(0, +)
        self.numNorthRiders = northRiders.values.reduce(0, +)
        self.numRandSeats = randDrivers.values.reduce(0, +)
        self.numNorthSeats = northDrivers.values.reduce(0, +)
        
        var difRand = self.numRandSeats - self.numRandRiders // keep as var to change later
        var difNorth = self.numNorthSeats - self.numNorthRiders // keep as var to change later

        for driver in self.noPrefDrivers {
            if difNorth < difRand {
                moveDriver(driverID: driver.key, fromList: "no_pref_driver", toList: "north_driver")
            } else {
                moveDriver(driverID: driver.key, fromList: "no_pref_driver", toList: "rand_driver")
            }
        }
    }
    
    private func moveDriver(driverID: String, fromList: String, toList: String) {
        let dateRef = Database.database().reference().child("Fall23-Practices").child(self.date)
        let fromListRef = dateRef.child(fromList)
        let toListRef = dateRef.child(toList)
        
        fromListRef.child(driverID).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let driverData = snapshot.value as? Int {
                    toListRef.child(driverID).setValue(driverData) { (error, _) in
                        if let error = error {
                            print("Error moving driver to target list: \(error.localizedDescription)")
                        } else {
                            print("MOVING DRIVER: \(driverID) FROM \(fromList) TO: \(toList)")
                            
                            fromListRef.child(driverID).removeValue { (error, _) in
                                if let error = error {
                                    print("Error removing driver from source list: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

