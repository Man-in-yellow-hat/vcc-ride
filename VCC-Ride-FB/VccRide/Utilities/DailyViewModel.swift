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
    func fetchDriverData(fromLocation: String, completion: @escaping ([Driver]) -> Void)
//    func fetchRiderData(fromLocation: String, completion: @escaping ([Climber]) -> Void)
    func fetchSeatCounts(completion: @escaping (SeatCounts) -> Void)
    func fetchDate(completion: @escaping (String) -> Void)
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
    
    func fetchDate(completion: @escaping (String) -> Void) {
        let ref = Database.database().reference().child("Daily-Practice").child("date")
        ref.observeSingleEvent(of: .value) { snapshot in
            if let fetchedDate = snapshot.value as? String {
                print("fetched:", fetchedDate)
                completion(fetchedDate)
            } else {
                completion("ERR")
            }
        }
    }
    
    func fetchDriverData(fromLocation: String, completion: @escaping ([Driver]) -> Void) {
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
                        let filledSeats = driverInfo["filled_seats"] as? Int ?? 0
                        let isDeparted = driverInfo["isDeparted"] as? Bool ?? false
                        let newDriver = Driver(id: driverID, name: name, location: fromLocation, seats: seats,
                                               filledSeats: filledSeats, preference: pref, isDeparted: isDeparted)
                        drivers.append(newDriver)
                    }
                }
            }
            completion(drivers)
        }
    }
    
    func fetchSeatCounts(completion: @escaping (SeatCounts) -> Void) {
            let practiceRef = Database.database().reference().child("Daily-Practice").child("seat_counts")
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



class DailyViewModel: ObservableObject {
    static let shared = DailyViewModel() // SINGLETON
    
    static var test = DailyViewModel()
    private var dataFetcher: PracticeDataFetching
    static func setSharedInstance(forTesting dataFetcher: PracticeDataFetching) {
        test = DailyViewModel(dataFetcher: dataFetcher)
    }
    public var practiceToday: Bool = false
    public var hasBeenAssigned: Bool = false
    public var isDriversListPopulated: Bool = false

    
    @Published var riders: [String: [String: Any]] = [:]
    @Published var drivers: [String: [String: Any]] = [:]
    
    @Published var numNorthRequested: Int = 0
    @Published var numNorthOffered: Int = 0
    @Published var numNorthFilled: Int = 0
    @Published var numRandRequested: Int = 0
    @Published var numRandOffered: Int = 0
    @Published var numRandFilled: Int = 0
    
    var numRandSeats = 0
    var numNorthSeats = 0
    var numRandRiders = 0
    var numNorthRiders = 0
    var difNorth = 0
    var difRand = 0
    
    public var date = ""
    
    private init(dataFetcher: PracticeDataFetching = FirebaseDataFetcher()) {
        self.dataFetcher = dataFetcher
        getDate()
        // all we have to do is check if drivers have already been assigned that day
        fetchDrivers() {}
        fetchRiders() {self.adjustSeats()}
    }
    
    public func checkPracticeToday(completion: @escaping (Bool) -> Void) {
        dataFetcher.fetchDate { fetchedDate in
            self.practiceToday = (fetchedDate == self.date)
        }
        completion(self.practiceToday)
    }
    
    private func getDate() {
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMdd"
        self.date = dateFormatter.string(from: today)
        
        checkPracticeToday{_ in }
    }
    
    public func adjustSeats() {
        let northRiders = filterRiders(locationFilter: "north")
        let randRiders = filterRiders(locationFilter: "rand")
        
        let northDrivers = filterDrivers(locationFilter: "north")
        let randDrivers = filterDrivers(locationFilter: "rand")
        
        numNorthRequested = northRiders.count
        numRandRequested = randRiders.count
        
        numNorthOffered = northDrivers.reduce(0) { $0 + ($1.value["seats"] as? Int ?? 0) }
        numRandOffered = randDrivers.reduce(0) { $0 + ($1.value["seats"] as? Int ?? 0) }
        
        numNorthFilled = northDrivers.reduce(0) { $0 + ($1.value["filled_seats"] as? Int ?? 0) }
        numRandFilled = randDrivers.reduce(0) { $0 + ($1.value["filled_seats"] as? Int ?? 0) }
        
//        print(numNorthRequested, numRandRequested, numNorthOffered, numRandOffered, numNorthFilled, numRandFilled)
        syncSeatCounts()
    }

    private func getSeatCounts() {
        dataFetcher.fetchSeatCounts { seatCounts in
            self.numNorthRequested = seatCounts.numNorthRequested
            self.numNorthOffered = seatCounts.numNorthOffered
            self.numNorthFilled = seatCounts.numNorthFilled
            self.numRandRequested = seatCounts.numRandRequested
            self.numRandOffered = seatCounts.numRandOffered
            self.numRandFilled = seatCounts.numRandFilled
        }
    }
    
    private func syncSeatCounts() {
        let practiceRef = Database.database().reference().child("Daily-Practice").child("seat_counts")

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
    

    //if hasBeenAssigned, get drivers list from daily
    //if not hasBeenAssigned, getList from Fall23, assignNoPrefDrivers, mark hasBeenAssigned true
    public func assignDrivers() {
        if (self.isDriversListPopulated) {
            return
        }
        
        self.difRand = self.numRandSeats - self.numRandRiders // keep as var to change later
        self.difNorth = self.numNorthSeats - self.numNorthRiders // keep as var to change later

        let ref = Database.database().reference().child("Daily-Practice")
        // Update has_been_assigned to true in the database
        ref.child("has_been_assigned").setValue(true)
        
        self.hasBeenAssigned = true
        self.isDriversListPopulated = true
    }
    
    func fetchDrivers(completion: @escaping () -> Void) {
        let drivers = Database.database().reference().child("Daily-Practice").child("drivers")
        drivers.observe(.value) { snapshot in
            if let values = snapshot.value as? [String: [String: Any]] {
                self.drivers = values
            }
            completion() // Call the completion handler when data is fetched
        }
    }
    
    func fetchRiders(completion: @escaping () -> Void) {
        let riders = Database.database().reference().child("Daily-Practice").child("riders")
        print("Observing users.")
        riders.observe(.value) { snapshot in
            if let values = snapshot.value as? [String: [String: Any]] {
                self.riders = values
            }
            completion() // Call the completion handler when data is fetched
        }
        
    }
    
    func filterRiders(locationFilter: String? = nil) -> [String: [String: Any]] {
        var filteredRiders = riders
        if let location = locationFilter {
            filteredRiders = filteredRiders.filter { (_, rider) in
                guard let userLocation = rider["location"] as? String else {return false}
                return userLocation == location
            }
        }
        return filteredRiders
    }
    
    func filterDrivers(locationFilter: String? = nil, isDepartedFilter: Bool? = false) -> [String: [String: Any]] {
        var filteredDrivers = drivers
        if let location = locationFilter {
            filteredDrivers = filteredDrivers.filter { (_, driver) in
                guard let userLocation = driver["location"] as? String else {return false}
                return userLocation == location
            }
        }
        if isDepartedFilter != nil {
            filteredDrivers = filteredDrivers.filter { (_, driver) in
                guard let driverDeparted = driver["isDeparted"] as? Bool else { return false }
                return driverDeparted == isDepartedFilter
            }
        }
        return filteredDrivers
    }
    
    func assignNoPref() {
        // Filter drivers with location "no_pref"
        let noPrefDrivers = filterDrivers(locationFilter: "no_pref")
        
        // Loop through each no_pref driver and assign to either "north" or "rand"
        for (driverID, driverInfo) in noPrefDrivers {
            // Extract the number of seats from the driver's information
            guard let seats = driverInfo["seats"] as? Int else {
                print("Error: Unable to retrieve the number of seats for driver \(driverID)")
                continue
            }
            
            // Decide the new location based on difNorth and difRand, incrementing the number of seats
            var newLocation: String = ""
            if (difNorth < difRand) {
                newLocation = "north"
                difNorth += seats
            } else {
                newLocation = "rand"
                difRand += seats
            }
            
            // Move the driver to the new location
            moveUser(userID: driverID, to: newLocation)
            
            // Print the information for demonstration purposes
            print("Driver \(driverID) moved to \(newLocation) with \(seats) seats.")
        }
    }
    
    func moveUser(userID: String, to newLocation: String) {
        // Identify whether the user is a rider or a driver
        var userType: String?
        
        if riders[userID] != nil {
            userType = "riders"
        }
        if drivers[userID] != nil {
            userType = "drivers"
        } else {
            // Handle the case when the user is not found
            return
        }
        
        // Update the location in the database
        let usersRef = Database.database().reference().child("Daily-Practice").child(userType!)
        let userLocationRef = usersRef.child(userID).child("location")
        
        userLocationRef.setValue(newLocation) { (error, _) in
            if let error = error {
                print("Error updating location: \(error.localizedDescription)")
            } else {
                // We are observing, so hopefully we should see it change
                
                print("User \(userID) moved successfully to \(newLocation)")
            }
        }
    }
    
    public func updateFilledSeats(forLocation: String, change: Int) {
        print("updating by: \(change)")
        var childToUpdate: String = ""
        if forLocation.lowercased().contains("north") {
            childToUpdate = "numNorthFilled"
        } else if forLocation.lowercased().contains("rand") {
            childToUpdate = "numRandFilled"
        }
        
        let countRef = Database.database().reference().child("Daily-Practice").child("seat_counts").child(childToUpdate)
        countRef.observeSingleEvent(of: .value) { snapshot in
            if let count = snapshot.value as? Int {
                countRef.setValue(count + change)
                if forLocation.lowercased().contains("north") {
                    self.numNorthFilled = count + change
                } else if forLocation.lowercased().contains("rand") {
                    self.numRandFilled = count + change
                }
            }
        }
    }
}
