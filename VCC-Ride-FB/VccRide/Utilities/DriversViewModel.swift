//
//  AssignNoPrefs.swift
//  VccRide
//
//  Created by Nathan King on 10/16/23.
//

import SwiftUI
import Firebase

class Climber: Identifiable {
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

class Driver: Climber {
    var locationPreference: String

    override init(id: String, name: String, location: String, seats: Int) {
        self.locationPreference = location
        super.init(id: id, name: name, location: location, seats: seats)
    }
}

// could have some sort of class allowing friends of android users to do stuff for them??

class DriversViewModel: ObservableObject {
    static let shared = DriversViewModel() // SINGLETON
    
    @Published var drivers: [Driver] = []
    @Published var riders: [Climber] = []
    public var hasBeenAssigned: Bool = false // TODO: RESET EACH DAY
    private var isDriversListPopulated: Bool = false

    private var numRandSeats = 0
    private var numNorthSeats = 0
    private var numRandRiders = 0
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
                
                // Create driver objects for north_drivers
                if let northDriversData = riderData["north_driver"] as? [String: [String: Any]] {
                    for (driverID, driverInfo) in northDriversData {
                        if let name = driverInfo["name"] as? String,
                           let seats = driverInfo["seats"] as? Int {
                            let northDriver = Driver(id: driverID, name: name, location: "NORTH", seats: seats)
                            self.drivers.append(northDriver)
                            self.numNorthSeats += seats
                        }
                    }
                }

                // Create driver objects for rand_drivers
                if let randDriversData = riderData["rand_driver"] as? [String: [String: Any]] {
                    for (driverID, driverInfo) in randDriversData {
                        if let name = driverInfo["name"] as? String,
                           let seats = driverInfo["seats"] as? Int {
                            let randDriver = Driver(id: driverID, name: name, location: "RAND", seats: seats)
                            self.drivers.append(randDriver)
                            self.numRandSeats += seats
                        }
                    }
                }

                // don't try to get noPrefs from Daily-Pracgtice
                if (fromWhere == "Fall23-Practices") {
                    if let noPrefDriversData = riderData["no_pref_driver"] as? [String: [String: Any]] {
                        for (driverID, driverInfo) in noPrefDriversData {
                            if let name = driverInfo["name"] as? String,
                               let seats = driverInfo["seats"] as? Int {
                                let noPrefDriver = Driver(id: driverID, name: name, location: "NONE", seats: seats)
                                self.drivers.append(noPrefDriver)
                                // don't add seats anywhere, will do that when we assign the drivers
                            }
                        }
                    }
                }

                // Notify observers of changes in driver data
                self.objectWillChange.send()
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
            print("getting lists from FALL")
            getDate()
            getLists(fromWhere: "Fall23-Practices")
            
            var difRand = self.numRandSeats - self.numRandRiders // keep as var to change later
            var difNorth = self.numNorthSeats - self.numNorthRiders // keep as var to change later

            for driver in drivers.filter({ $0.locationPreference == "NONE" }) { // assign no pref drivers
                if difNorth < difRand {
                    moveDriver(dbChild: "Fall23-Practices", driverID: driver.id, thisDriverSeats: driver.seats, fromList: "no_pref_driver", toList: "north_driver")
                    difNorth += driver.seats
                    driver.location = "NORTH"
                } else {
                    moveDriver(dbChild: "Fall23-Practices", driverID: driver.id, thisDriverSeats: driver.seats, fromList: "no_pref_driver", toList: "rand_driver")
                    difRand += driver.seats
                    driver.location = "RAND"
                }
            }
            self.hasBeenAssigned = true
        }
        self.isDriversListPopulated = true
    }
    
    public func moveDriver(dbChild: String, driverID: String, thisDriverSeats: Int, fromList: String, toList: String) {
        let databaseRef = Database.database().reference().child(dbChild)
        var practiceRef = databaseRef
        if (dbChild == "Fall23-Pratices") {
            practiceRef = practiceRef.child(self.date)
        }
        
        let fromListRef = practiceRef.child(fromList)
        let toListRef = practiceRef.child(toList)
        

        fromListRef.child(driverID).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                // Write the entire node and its subnodes to the destination location
                toListRef.child(driverID).setValue(data) { (error, _) in
                    if let error = error {
                        print("Error moving driver to target list: \(error.localizedDescription)")
                    } else {
                        print("MOVING DRIVER: \(driverID) FROM \(fromList) TO: \(toList)")
                        
                        // Delete the entire node and its subnodes from the source location
                        fromListRef.child(driverID).removeValue { (error, _) in
                            if let error = error {
                                print("Error removing driver from source list: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        objectWillChange.send()
    }
}

