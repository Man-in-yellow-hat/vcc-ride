//
//  UserModel.swift
//  VccRide
//
//  Created by Karen Pu on 11/13/23.
//

import Foundation
import SwiftUI


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

