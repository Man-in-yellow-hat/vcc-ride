//
//  AssignNoPrefs.swift
//  VccRide
//
//  Created by Nathan King on 11/13/23.
//

import SwiftUI
import Firebase

class DriverViewModel: ObservableObject {
    private var filledSeatsCount: Int = 0
    
    public func toggleSeat(at: Int) {
        if (at + 1) <= filledSeatsCount { // tapping a filled seat
            self.filledSeatsCount -= 1
        
        } else {
            self.filledSeatsCount += 1
        }
    }

    public func filledSeatCounts() -> Int {
       return filledSeatsCount
    }
    
    public func updateNumFilledSeats(forLocation: String, count: Int) {
        
    }

}
