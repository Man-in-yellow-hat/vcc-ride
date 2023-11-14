//
//  AssignNoPrefs.swift
//  VccRide
//
//  Created by Nathan King on 10/16/23.
//

import SwiftUI
import Firebase

struct SeatCounts {
    var numNorthRequested: Int
    var numNorthOffered: Int
    var numNorthFilled: Int
    var numRandRequested: Int
    var numRandOffered: Int
    var numRandFilled: Int
}

protocol PracticeDataFetching {
    func checkDriverAssignment(completion: @escaping (Bool) -> Void)
    func fetchDriverData(fromLocation: String, assignedLocation: String, completion: @escaping ([Driver]) -> Void)
    func fetchRiderData(fromLocation: String, assignedLocation: String, completion: @escaping ([Climber]) -> Void)
    func fetchSeatCounts(completion: @escaping (SeatCounts) -> Void)
}

class FirebaseDataFetcher: PracticeDataFetching {
    func checkDriverAssignment(completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("Daily-Practice").child("has_been_assigned")
        ref.observeSingleEvent(of: .value) { snapshot in
            if let isAssigned = snapshot.value as? Bool {
                print("found")
                completion(isAssigned)
            } else {
                completion(false)
            }
        }
    }
    func fetchDriverData(fromLocation: String, assignedLocation: String, completion: @escaping ([Driver]) -> Void) {
        let practiceRef = Database.database().reference().child("Daily-Practice")

        practiceRef.observe(.value) { snapshot, error in
            if let error = error {
                print("Error fetching driver data: \(error)")
                completion([])
                return
            }

            var drivers: [Driver] = []
            if let driverData = snapshot.value as? [String: Any],
               let listData = driverData[fromLocation] as? [String: [String: Any]] {
                
                for (driverID, driverInfo) in listData {
                    if let name = driverInfo["name"] as? String,
                       let seats = driverInfo["seats"] as? Int,
                       let pref = driverInfo["preference"] as? String {
                        let newDriver = Driver(id: driverID, name: name, location: assignedLocation,
                                                seats: seats, preference: pref)
                        drivers.append(newDriver)
                    }
                }
            }
            completion(drivers)
        }
    }
    
    func fetchRiderData(fromLocation: String, assignedLocation: String, completion: @escaping ([Climber]) -> Void) {
            let practiceRef = Database.database().reference().child("Daily-Practice").child(fromLocation)

            practiceRef.observeSingleEvent(of: .value) { snapshot, error in
                var climbers: [Climber] = []

                if let error = error {
                    print("Error fetching rider data: \(error)")
                    completion([])
                    return
                }

                if let listData = snapshot.value as? [String: [String: Any]] {
                    for (climberID, climberInfo) in listData {
                        if let name = climberInfo["name"] as? String,
                           let seats = climberInfo["seats"] as? Int {
                            let newClimber = Climber(id: climberID, name: name, location: assignedLocation, seats: seats)
                            climbers.append(newClimber)
                        }
                    }
                }
                completion(climbers)
            }
        }
    
    func fetchSeatCounts(completion: @escaping (SeatCounts) -> Void) {
            let practiceRef = Database.database().reference().child("Daily-Practice").child("seatCounts")
            practiceRef.observe(.value) { snapshot, error in
                guard let data = snapshot.value as? [String: Any] else {
                    completion(SeatCounts(numNorthRequested: 0, numNorthOffered: 0, numNorthFilled: 0,
                                          numRandRequested: 0, numRandOffered: 0, numRandFilled: 0))
                    return
                }

                let seatCounts = SeatCounts(
                    numNorthRequested: data["numNorthRequested"] as? Int ?? 0,
                    numNorthOffered: data["numNorthOffered"] as? Int ?? 0,
                    numNorthFilled: data["numNorthFilled"] as? Int ?? 0,
                    numRandRequested: data["numRandRequested"] as? Int ?? 0,
                    numRandOffered: data["numRandOffered"] as? Int ?? 0,
                    numRandFilled: data["numRandFilled"] as? Int ?? 0
                )
                completion(seatCounts)
            }
        }
}




// could have some sort of class allowing friends of android users to do stuff for them??

class DailyViewModel: ObservableObject {
    static let shared = DailyViewModel() // SINGLETON
    
    static var test = DailyViewModel()
    private var dataFetcher: PracticeDataFetching
    static func setSharedInstance(forTesting dataFetcher: PracticeDataFetching) {
        test = DailyViewModel(dataFetcher: dataFetcher)
    }
    
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

    var numRandSeats = 0
    var numNorthSeats = 0
    var numRandRiders = 0
    var numNorthRiders = 0
    
    var difNorth = 0
    var difRand = 0
    
    public var date = ""
    
    private init(dataFetcher: PracticeDataFetching = FirebaseDataFetcher()) {
        self.dataFetcher = dataFetcher
        // all we have to do is check if drivers have already been assigned that day
        dataFetcher.checkDriverAssignment { [weak self] isAssigned in
            self?.hasBeenAssigned = isAssigned
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
                self.numNorthOffered += deltaSeats
            } else {
                self.numRandOffered += deltaSeats
            }
        } else {
            if (isNorth) {
                self.numNorthRequested += deltaSeats
            } else {
                self.numRandRequested += deltaSeats
            }
        }
        syncSeatCounts()
    }
    
    private func getSeatCounts() {
// <<<<<<< nathan_new
//         let practiceRef = Database.database().reference().child("Daily-Practice").child("seatCounts")
//         practiceRef.observeSingleEvent(of: .value) { snapshot, error in
//             if let data = snapshot.value as? [String: Any] {
//                 if let numNorthRequested = data["numNorthRequested"] as? Int,
//                    let numRandRequested = data["numRandRequested"] as? Int,
//                    let numNorthOffered = data["numNorthOffered"] as? Int,
//                    let numRandOffered = data["numRandOffered"] as? Int,
//                    let numNorthFilled = data["numNorthFilled"] as? Int,
//                    let numRandFilled = data["numRandFilled"] as? Int {
//                     self.numNorthRequested = numNorthRequested
//                     self.numRandRequested = numRandRequested
//                     self.numNorthOffered = numNorthOffered
//                     self.numRandOffered = numRandOffered
//                     self.numNorthFilled = numNorthFilled
//                     self.numRandFilled = numRandFilled
//                 }
//             }
// =======
        dataFetcher.fetchSeatCounts { seatCounts in
            self.numNorthRequested = seatCounts.numNorthRequested
            self.numNorthOffered = seatCounts.numNorthOffered
            self.numNorthFilled = seatCounts.numNorthFilled
            self.numRandRequested = seatCounts.numRandRequested
            self.numRandOffered = seatCounts.numRandOffered
            self.numRandFilled = seatCounts.numRandFilled
// >>>>>>> main
        }
    }
    
    private func syncSeatCounts() {
        let practiceRef = Database.database().reference().child("Daily-Practice").child("seatCounts")

        let seatCountsData: [String: Any] = [
            "numNorthRequested": self.numNorthRequested,
            "numRandRequested": self.numRandRequested,
            "numNorthOffered": self.numNorthOffered,
            "numRandOffered": self.numRandOffered,
            "numNorthFilled": self.numNorthFilled,
            "numRandFilled": self.numRandFilled
        ]

        practiceRef.setValue(seatCountsData) { error, _ in
            if let error = error {
                print("Failed to update seat counts in the database: \(error.localizedDescription)")
            } else {
                print("Seat counts updated successfully in the database.")
            }
        }
        self.objectWillChange.send()
    }
    
    public func getDriverList(fromLocation: String, assignedLocation: String) {
        dataFetcher.fetchDriverData(fromLocation: fromLocation, assignedLocation: assignedLocation) { drivers in
            for newDriver in drivers {
                // Location-specific logic
                if fromLocation == "north_drivers" && !self.northDrivers.contains(where: { $0.id == newDriver.id }) {
                    self.northDrivers.append(newDriver)
                    self.adjustSeats(isDriver: true, isNorth: true, deltaSeats: newDriver.seats)
                } else if fromLocation == "rand_drivers" && !self.randDrivers.contains(where: { $0.id == newDriver.id }) {
                    self.randDrivers.append(newDriver)
                    self.adjustSeats(isDriver: true, isNorth: false, deltaSeats: newDriver.seats)
                } else if fromLocation == "no_pref_drivers" {
                    self.assignNoPref(driver: newDriver)
                }
            }
            self.objectWillChange.send()
        }
    }

    public func getRiderList(fromLocation: String, assignedLocation: String) {
        dataFetcher.fetchRiderData(fromLocation: fromLocation, assignedLocation: assignedLocation) { climbers in
            for newClimber in climbers {
                if fromLocation == "north_riders" && !self.northClimbers.contains(where: { $0.id == newClimber.id }) {
                    self.northClimbers.append(newClimber)
                } else if fromLocation == "rand_riders" && !self.randClimbers.contains(where: { $0.id == newClimber.id }) {
                        self.randClimbers.append(newClimber)
                }

                self.adjustSeats(isDriver: false, isNorth: fromLocation == "north_riders", deltaSeats: newClimber.seats)
            }
            self.objectWillChange.send()
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
    
    // TESTING: demonstrate black box testing, show in database that driver got moved
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

