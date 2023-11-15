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
    var isDeparted: Bool
    var displayLocation: String

    init(id: String, name: String, location: String, seats: Int, filledSeats: Int, preference: String, isDeparted: Bool) {
        self.displayLocation = ""
        self.locationPreference = preference
        self.filledSeats = filledSeats
        self.isDeparted = isDeparted
        super.init(id: id, name: name, location: location, seats: seats)
        if (self.location == "north_drivers") {
            self.displayLocation = "North"
        } else if self.location == "rand_drivers" {
            self.displayLocation = "Rand"
        }
    }
    
    public func toggleSeat(at: Int) -> Int {
        var change: Int = self.filledSeats
        if (at == -1) {
            self.filledSeats = 0
            change *= -1
        } else if (self.filledSeats == at + 1) {
            self.filledSeats -= 1
            change = -1
        } else {
            self.filledSeats = at + 1
            change = at + 1
        }
        let dailyRef = Database.database().reference().child("Daily-Practice")
        let personalRef = dailyRef.child(self.location).child(self.id).child("filled_seats")
        personalRef.setValue(self.filledSeats)
        return change
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

