//
//  MockDatabase.swift
//  VccRideTests
//
//  Created by Karen Pu on 11/12/23.
//

import Foundation
@testable import VccRide


class MockDataFetcher: PracticeDataFetching {
    
    
    func checkDriverAssignment(completion: @escaping (Bool) -> Void) {
        let isAssigned = true
        completion(isAssigned)
    }
    func fetchDriverData(fromLocation: String, assignedLocation: String, completion: @escaping ([VccRide.Driver]) -> Void) {
        let mockDrivers: [VccRide.Driver] = [
            VccRide.Driver(id: "1", name: "Mock Driver 1", location: "north_drivers", seats: 3, preference: "NORTH"),
            VccRide.Driver(id: "2", name: "Mock Driver 2", location: "north_drivers", seats: 2, preference: "NORTH"),
            VccRide.Driver(id: "5", name: "Mock Driver 5", location: "north_drivers", seats: 3, preference: "NORTH"),
        ]
        completion(mockDrivers)
    }
    
    func fetchRiderData(fromLocation: String, assignedLocation: String, completion: @escaping ([VccRide.Climber]) -> Void) {
        let mockRiders: [VccRide.Climber] = [
            VccRide.Climber (id: "6", name: "Mock Rider 1", location: "rand_riders", seats: 1),
            VccRide.Climber (id: "9", name: "Mock Rider 4", location: "rand_riders", seats: 1)
        ]
        completion(mockRiders)
    }
    
    func fetchSeatCounts(completion: @escaping (VccRide.SeatCounts) -> Void) {
        let mockSeatCounts: VccRide.SeatCounts = VccRide.SeatCounts(numNorthRequested: 6, numNorthOffered: 8, numNorthFilled: 10, numRandRequested: 2, numRandOffered: 3, numRandFilled: 5)
        completion(mockSeatCounts)
    }
}
    
    
