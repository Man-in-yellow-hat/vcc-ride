//
//  AssignNoPrefs.swift
//  VccRide
//
//  Created by Nathan King on 10/16/23.
//

import SwiftUI
import Firebase

class Driver: Identifiable {
    var id: String // Unique identifier for the driver
    var name: String // Driver's name
    var location: String // Driver's location (e.g., "NORTH" or "RAND")
    var seats: Int // Driver's number of seats

    init(id: String, name: String, location: String, seats: Int) {
        self.id = id
        self.name = name
        self.location = location
        self.seats = seats
    }
}

class DriversViewModel: ObservableObject {
    static let shared = DriversViewModel() // SINGLETON
    
    @Published var drivers: [Driver] = []
    public var hasBeenAssigned: Bool = false // TODO: RESET EACH DAY
    private var isDriversListPopulated: Bool = false

    public var randDrivers = [String:Int]()
    private var numRandSeats = 0
    
    public var northDrivers = [String:Int]()
    private var numNorthSeats = 0
    
    public var noPrefDrivers = [String:Int]()
    
    private var randRiders = [String:Int]()
    private var numRandRiders = 0
    
    private var northRiders = [String:Int]()
    private var numNorthRiders = 0
    
    private var date = ""
    
    private init() {
        // all we have to do is check if drivers have already been assigned that day
        let ref = Database.database().reference().child("Daily-Practice").child("has_been_assigned")
        ref.observeSingleEvent(of: .value) { snapshot, error in
            if let isAssigned = snapshot.value as? Bool {
                self.hasBeenAssigned = isAssigned
            }
        }
    }
    
    private func getDate() {
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd" // TODO: decide on date format
        self.date = dateFormatter.string(from: today)
    }
    
    private func getLists(fromWhere: String) {
        let databaseRef = Database.database().reference().child(fromWhere)
        var practiceRef = databaseRef
        if (fromWhere == "Fall23-Pratices") {
            practiceRef = practiceRef.child(self.date)
        }

        practiceRef.observeSingleEvent(of: .value) { snapshot, error in
            if let riderData = snapshot.value as? [String: Any] {
                print("here1")
                
                // Create driver objects for north_drivers
                if let northDriversData = riderData["north_driver"] as? [String: [String: Any]] {
                    for (driverID, driverInfo) in northDriversData {
                        print("here2")
                        if let name = driverInfo["name"] as? String,
                           let seats = driverInfo["seats"] as? Int {
                            let driver = Driver(id: driverID, name: name, location: "NORTH", seats: seats)
                            print("here3")
                            self.drivers.append(driver)
                        }
                    }
                }

                // Create driver objects for rand_drivers
                if let randDriversData = riderData["rand_driver"] as? [String: [String: Any]] {
                    for (driverID, driverInfo) in randDriversData {
                        if let name = driverInfo["name"] as? String,
                           let seats = driverInfo["seats"] as? Int {
                            let driver = Driver(id: driverID, name: name, location: "RAND", seats: seats)
                            self.drivers.append(driver)
                        }
                    }
                }

                // don't try to get noPrefs from Daily-Pracgtice
                if (fromWhere == "Fall23-Practices") {
                    if let noPrefDriversData = riderData["no_pref_driver"] as? [String: [String: Any]] {
                        for (driverID, driverInfo) in noPrefDriversData {
                            if let name = driverInfo["name"] as? String,
                               let seats = driverInfo["seats"] as? Int {
                                let driver = Driver(id: driverID, name: name, location: "NONE", seats: seats)
                                self.drivers.append(driver)
                            }
                        }
                    }
                }

                // Notify observers of changes in driver data
                self.objectWillChange.send() // is this necessary?
            }
        }
    }
    
    //if hasBeenAssigned, get drivers list from daily
    //if not hasBeenAssigned, getList from Fall23, assignNoPrefDrivers, mark hasBeenAssigned true
    public func assignDrivers() {
        if (self.isDriversListPopulated) {
            return
        }
        if (self.hasBeenAssigned) {
            print("getting lists from DAILY")
            getLists(fromWhere: "Daily-Practice")
        } else {
            getDate()
            print("getting lists from FALL")
            getLists(fromWhere: "Fall23-Practices")
            self.numRandRiders = randRiders.values.reduce(0, +)
            self.numNorthRiders = northRiders.values.reduce(0, +)
            self.numRandSeats = randDrivers.values.reduce(0, +)
            self.numNorthSeats = northDrivers.values.reduce(0, +)
            
            var difRand = self.numRandSeats - self.numRandRiders // keep as var to change later
            var difNorth = self.numNorthSeats - self.numNorthRiders // keep as var to change later

            for driver in self.noPrefDrivers {
                //
                var mySeats = 4
                mySeats = driver.value
                if difNorth < difRand {
                    moveDriver(dbChild: "Fall23-Practices", driverID: driver.key, thisDriverSeats: mySeats, fromList: "no_pref_driver", toList: "north_driver")
                    difNorth += mySeats
                } else {
                    moveDriver(dbChild: "Fall23-Practices", driverID: driver.key, thisDriverSeats: mySeats, fromList: "no_pref_driver", toList: "rand_driver")
                    difRand += mySeats
                }
            }
            self.hasBeenAssigned = true
        }
        self.isDriversListPopulated = true
    }
    
    public func moveDriver(dbChild: String, driverID: String, thisDriverSeats: Int, fromList: String, toList: String) {
        let dateRef = Database.database().reference().child(dbChild).child(self.date)
        let fromListRef = dateRef.child(fromList)
        let toListRef = dateRef.child(toList)
        
        
        fromListRef.child(driverID).observeSingleEvent(of: .value) { snapshot in
            toListRef.child(driverID).setValue(thisDriverSeats) { (error, _) in
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

