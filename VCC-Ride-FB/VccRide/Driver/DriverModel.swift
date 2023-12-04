//
//  UserModel.swift
//  VccRide
//
//  Created by Nathan King on 11/30/23.
//

import SwiftUI
import Firebase

class Driver {
    var id: String
    var name: String
    var location: String
    var seats: Int
    var filledSeats: Int
    var locationPreference: String
    var isDeparted: Bool
    
    init(id: String, name: String, location: String, seats: Int, filledSeats: Int, preference: String, isDeparted: Bool) {
        self.id = id
        self.name = name
        self.location = location
        self.seats = seats
        self.locationPreference = preference
        self.filledSeats = filledSeats
        self.isDeparted = isDeparted
    }
    
    public func toggleSeat(at: Int) -> Int {
        let before: Int = self.filledSeats
        if (at == -1) {
            self.filledSeats = 0
        } else if (self.filledSeats == at + 1) {
            self.filledSeats -= 1
        } else {
            self.filledSeats = at + 1
        }
        let change: Int = self.filledSeats - before
        let dailyRef = Database.database().reference().child("Daily-Practice")
        let personalRef = dailyRef.child("drivers").child(self.id).child("filled_seats")
        personalRef.setValue(self.filledSeats)
        print("changing by: \(change)")
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
