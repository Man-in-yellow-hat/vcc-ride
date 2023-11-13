//
//  MockDatabase.swift
//  VccRideTests
//
//  Created by Karen Pu on 11/12/23.
//

import Foundation
@testable import VccRide


final class MockDataFetcher: PracticeDataFetching {
    func checkDriverAssignment(completion: @escaping (Bool) -> Void) {
        let isAssigned = true
        completion(isAssigned)
    }
    func fetchDriverData(fromLocation: String, assignedLocation: String, completion: @escaping ([VccRide.Driver]) -> Void) {
        let mockDrivers: [VccRide.Driver] = [
            VccRide.Driver(id: "1", name: "Mock Driver 1", location: "", seats: 3, preference: "NORTH"),
            VccRide.Driver(id: "2", name: "Mock Driver 2", location: "", seats: 2, preference: "NORTH"),
            VccRide.Driver(id: "3", name: "Mock Driver 3", location: "", seats: 4, preference: "RAND"),
            VccRide.Driver(id: "4", name: "Mock Driver 4", location: "", seats: 1, preference: "NONE"),
            VccRide.Driver(id: "5", name: "Mock Driver 5", location: "", seats: 3, preference: "NONE"),
        ]
        completion(mockDrivers)
    }
    
    func fetchRiderData(fromLocation: String, assignedLocation: String, completion: @escaping ([VccRide.Climber]) -> Void) {
        let mockRiders: [VccRide.Climber] = [
            VccRide.Climber (id: "6", name: "Mock Rider 1", location: "NORTH", seats: 1),
            VccRide.Climber (id: "7", name: "Mock Rider 2", location: "NORTH", seats: 1),
            VccRide.Climber (id: "8", name: "Mock Rider 3", location: "RAND", seats: 1),
            VccRide.Climber (id: "9", name: "Mock Rider 4", location: "RAND", seats: 1),
            VccRide.Climber (id: "10", name: "Mock Rider 5", location: "NORTH", seats: 1),
        ]
        completion(mockRiders)
    }
    
    func fetchSeatCounts(completion: @escaping (VccRide.SeatCounts) -> Void) {
        var mockSeatCounts: VccRide.SeatCounts = VccRide.SeatCounts(numNorthRequested: 6, numNorthOffered: 8, numNorthFilled: 10, numRandRequested: 2, numRandOffered: 3, numRandFilled: 5)
        completion(mockSeatCounts)
    }
}
    
    
