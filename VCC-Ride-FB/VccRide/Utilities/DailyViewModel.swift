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

    init(id: String, name: String, location: String, seats: Int, preference: String) {
        self.locationPreference = preference
        super.init(id: id, name: name, location: location, seats: seats)
    }
}

// could have some sort of class allowing friends of android users to do stuff for them??

class DailyViewModel: ObservableObject {
    static let shared = DailyViewModel() // SINGLETON
    
//    @Published var drivers: [Driver] = []
//    @Published var riders: [Climber] = []
    
    @Published var northDrivers: [Driver] = []
    @Published var randDrivers: [Driver] = []
    @Published var northClimbers: [Climber] = []
    @Published var randClimbers: [Climber] = []
    
    @Published var numNorthRequested: Int = 0
    @Published var numNorthOffered: Int = 0
    @Published var numNorthFilled: Int = 0
    @Published var numRandRequested: Int = 0
    @Published var numRandOffered: Int = 0
    @Published var numRandFilled: Int = 0
    
    public var hasBeenAssigned: Bool = false // TODO: RESET EACH DAY
    public var isDriversListPopulated: Bool = false

    private var numRandSeats = 0
    private var numNorthSeats = 0
    private var numRandRiders = 0
    private var numNorthRiders = 0
    
    private var difNorth = 0
    private var difRand = 0
    
    public var date = ""
    
    private init() {
        // all we have to do is check if drivers have already been assigned that day
        let ref = Database.database().reference().child("Daily-Practice").child("has_been_assigned")
        ref.observe(.value) { snapshot, error in
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
    
    
    private func adjustSeats(isDriver: Bool, isNorth: Bool, deltaSeats: Int) {
        if (isDriver) {
            if (isNorth) {
                self.numNorthSeats += deltaSeats
            } else {
                self.numRandSeats += deltaSeats
            }
        } else {
            if (isNorth) {
                self.numNorthRiders += deltaSeats
            } else {
                self.numRandRiders += deltaSeats
            }
        }
    }
    
    private func getSeatCounts() {
        let practiceRef = Database.database().reference().child("Daily-Practice").child("seatCounts")
        practiceRef.observe(.value) { snapshot, error in
            if let data = snapshot.value as? [String: Any] {
                if let numNorthRequested = data["numNorthRequested"] as? Int,
                   let numRandRequested = data["numRandRequested"] as? Int,
                   let numNorthOffered = data["numNorthOffered"] as? Int,
                   let numRandOffered = data["numRandOffered"] as? Int,
                   let numNorthFilled = data["numNorthFilled"] as? Int,
                   let numRandFilled = data["numRandFilled"] as? Int {
                    self.numNorthRequested = numNorthRequested
                    self.numRandRequested = numRandRequested
                    self.numNorthOffered = numNorthOffered
                    self.numRandOffered = numRandOffered
                    self.numNorthFilled = numNorthFilled
                    self.numRandFilled = numRandFilled
                }
            }
        }
    }
    
    public func getDriverList(fromLocation: String, assignedLocation: String) {
        let practiceRef = Database.database().reference().child("Daily-Practice")
    
        practiceRef.observe(.value) { snapshot, error in
            if let driverData = snapshot.value as? [String: Any] {
                if let listData = driverData[fromLocation] as? [String: [String: Any]] {
                    // Make a new driver object for each driver
                    for (driverID, driverInfo) in listData {
                        if let name = driverInfo["name"] as? String,
                           let seats = driverInfo["seats"] as? Int,
                           let pref = driverInfo["preference"] as? String {
                            let newDriver = Driver(id: driverID, name: name, location: assignedLocation,
                                                     seats: seats, preference: pref)
                            if (fromLocation == "north_drivers" && !self.northDrivers.contains(where: { $0.id == newDriver.id })) {
                                self.northDrivers.append(newDriver)
                                self.adjustSeats(isDriver: true, isNorth: (fromLocation == "north_drivers"), deltaSeats: seats)
                            } else if (fromLocation == "rand_drivers" && !self.randDrivers.contains(where: { $0.id == newDriver.id})) {
                                self.randDrivers.append(newDriver)
                                self.adjustSeats(isDriver: true, isNorth: (fromLocation == "north_drivers"), deltaSeats: seats)
                            } else if (fromLocation == "no_pref_driers") { // location is noPref
                                self.assignNoPref(driver: newDriver)
                            }
                        }
                    }
                }
                self.objectWillChange.send()
            }
        }
    }
    
    public func getRiderList(fromLocation: String, assignedLocation: String) {
        let practiceRef = Database.database().reference().child("Daily-Practice")
        
        practiceRef.observe(.value) { snapshot, error in
            if let error = error {
                print("Error observing practice data: \(error)")
                return
            }

            if let riderData = snapshot.value as? [String: Any] {
                if let listData = riderData[fromLocation] as? [String: [String: Any]] {
                    // Make a new climber object for each climber
                    for (climberID, climberInfo) in listData {
                        if let name = climberInfo["name"] as? String,
                           let seats = climberInfo["seats"] as? Int {
                            let newClimber = Climber(id: climberID, name: name, location: assignedLocation, seats: seats)
                            
                            if (fromLocation == "rand_riders" && !self.randClimbers.contains(where: { $0.id == newClimber.id })) {
                                self.randClimbers.append(newClimber)
                                self.adjustSeats(isDriver: false, isNorth: (fromLocation == "north_riders"), deltaSeats: seats)
                            } else if (fromLocation == "north_riders" && !self.northClimbers.contains(where: { $0.id == newClimber.id })) {
                                self.northClimbers.append(newClimber)
                                self.adjustSeats(isDriver: false, isNorth: (fromLocation == "north_riders"), deltaSeats: seats)
                            }
                        } else {
                            print("Error parsing climber information for climber ID \(climberID)")
                        }
                    }
                } else {
                    print("Error accessing list data for location \(fromLocation)")
                }
                self.objectWillChange.send()
            } else {
                print("Error parsing rider data")
            }
        }
    }

    
    //if hasBeenAssigned, get drivers list from daily
    //if not hasBeenAssigned, getList from Fall23, assignNoPrefDrivers, mark hasBeenAssigned true
    public func assignDrivers() {
        if (self.isDriversListPopulated) {
            return
        }

        print("getting lists from DAILY")
        getDate()
        getDriverList(fromLocation: "north_drivers", assignedLocation: "NORTH")
        getDriverList(fromLocation: "rand_drivers", assignedLocation: "RAND")
        getDriverList(fromLocation: "no_pref_drivers", assignedLocation: "NONE")
        getRiderList(fromLocation: "north_riders", assignedLocation: "NORTH")
        getRiderList(fromLocation: "rand_riders", assignedLocation: "RAND")
        
        self.difRand = self.numRandSeats - self.numRandRiders // keep as var to change later
        self.difNorth = self.numNorthSeats - self.numNorthRiders // keep as var to change later

        self.hasBeenAssigned = true
        self.isDriversListPopulated = true
    }
    
    public func assignNoPref(driver: Driver) {
        print("assigning nopref")
        if difNorth < difRand {
            moveDriver(dbChild: "Daily-Practice", driverID: driver.id, fromList: "no_pref_drivers", toList: "north_drivers")
            difNorth += driver.seats
            driver.location = "NORTH"
            self.northDrivers.append(driver)
        } else {
            moveDriver(dbChild: "Daily-Practice", driverID: driver.id, fromList: "no_pref_drivers", toList: "rand_drivers")
            difRand += driver.seats
            driver.location = "RAND"
            self.randDrivers.append(driver)
        }
        objectWillChange.send()
    }
    
    public func moveDriver(dbChild: String, driverID: String, fromList: String, toList: String) {
        let databaseRef = Database.database().reference().child(dbChild)
        var practiceRef = databaseRef
        if (dbChild == "Fall23-Pratices") {
            practiceRef = practiceRef.child(self.date)
        }
        
        let fromListRef = practiceRef.child(fromList)
        let toListRef = practiceRef.child(toList)
        
//        print("moving", dbChild, driverID, fromList, toList)
        fromListRef.child(driverID).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                // Delete the entire node and its subnodes from the source location
                fromListRef.child(driverID).removeValue { (error, _) in
                    if let error = error {
                        print("Error removing driver from source list: \(error.localizedDescription)")
                    } else {
                        // Write the entire node and its subnodes to the destination location
                        toListRef.child(driverID).setValue(data) { (error, _) in
                            if let error = error {
                                print("Error moving driver to target list: \(error.localizedDescription)")
                            } else {
                                print("MOVING DRIVER: \(driverID) FROM \(fromList) TO: \(toList)")
                            }
                        }
                    }
                }
            } else {
                print("here, shouldn't be")
            }
        }
        objectWillChange.send()
    }

}

