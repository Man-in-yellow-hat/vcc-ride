//
//  AssignNoPrefs.swift
//  VccRide
//
//  Created by Nathan King on 11/13/23.
//

import SwiftUI
import Firebase

class DriverViewModel: ObservableObject {
    public var filledSeatsCount: Int = 0
    
    public func toggleSeat(at: Int) {
        // toggles a seat from open to filled or vice versa
    }

    public func isSeatFilled(at: Int) -> Bool {
        // checks if a seat is filled
        return false
    }

    public func filledSeatCounts() -> Int {
       return 0
    }
    
    public func updateNumFilledSeats(forLocation: String, count: Int) {
        
    }

}
