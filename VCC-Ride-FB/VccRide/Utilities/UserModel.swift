//
//  UserModel.swift
//  VccRide
//
//  Created by Karen Pu on 11/13/23.
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
    var filledSeats: Int

    init(id: String, name: String, location: String, seats: Int, preference: String) {
        self.locationPreference = preference
        self.filledSeats = 0
        super.init(id: id, name: name, location: location, seats: seats)
    }
    
//    public func toggleSeat(at: Int) {
//        let delta: Int = (self.filledSeats == at + 1) ? -1 : 1
//        self.filledSeats += delta
//
//        let dailyRef = Database.database().reference().child("Daily-Practice")
//        let seatCountRef = dailyRef.child("seat_count")
//
////        // Fetch the current location data
////        seatCountRef.observeSingleEvent(of: .value) { [weak self] snapshot in
////            guard let self = self else { return }
////
////            guard let locationData = snapshot.value as? [String: Any] else {
////                print("Error: Unable to fetch location data.")
////                return
////            }
////
////            if self.location == "north_drivers" {
////                seatCountRef.child("numNorthFilled").setValue((locationData["numNorthFilled"] as? Int ?? 0) + delta)
////            } else if self.location == "rand_drivers" {
////                seatCountRef.child("numRandFilled").setValue((locationData["numRandFilled"] as? Int ?? 0) + delta)
////            }
////
////            let personalRef = dailyRef.child(self.location).child(self.id).child("filled_seats")
////            personalRef.setValue(self.filledSeats)
////        }
//    }
    
    public func toggleSeat(at: Int) {
        if (self.filledSeats == at + 1) {
            self.filledSeats -= 1
        } else {
            self.filledSeats = at + 1
        }
        let dailyRef = Database.database().reference().child("Daily-Practice")
        let filledRef = dailyRef.child("seat_counts")
        let personalRef = dailyRef.child(self.location).child(self.id).child("filled_seats")
        personalRef.setValue(self.filledSeats)
    }
    
    public func isSeatFilled(at: Int) -> Bool {
        return (at + 1) <= self.filledSeats
    }

    public func filledSeatCounts() -> Int {
       return filledSeats
    }
    
    public func isFull() -> Bool {
        return self.filledSeats == self.seats
    }
}

