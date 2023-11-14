//
//  DailyViewModelTests.swift
//  VccRideTests
//
//  Created by Karen Pu on 11/13/23.
//
import XCTest
@testable import VccRide

final class DailyViewModelTests: XCTestCase {
    var sut: DailyViewModel!
    var mockDataFetcher: MockDataFetcher!

    override func setUp() {
        super.setUp()
        mockDataFetcher = MockDataFetcher()
        DailyViewModel.setSharedInstance(forTesting: mockDataFetcher)
        sut = DailyViewModel.test
    }

    override func tearDown() {
        sut = nil
        mockDataFetcher = nil
        super.tearDown()
    }

    func testDifferencesinAssignDrivers() {
        
        let viewModel = DailyViewModel.shared

        // Set up test data
        viewModel.numRandSeats = 10 // Example data
        viewModel.numRandRiders = 8  // Example data
        viewModel.numNorthSeats = 4  // Example data
        viewModel.numNorthRiders = 1 // Example data

        // Invoke the method under test
        viewModel.assignDrivers()

        // Assert that the differences are calculated correctly
        XCTAssertEqual(viewModel.difRand, 2, "difRand should be the difference between numRandSeats and numRandRiders")
        XCTAssertEqual(viewModel.difNorth, 3, "difNorth should be the difference between numNorthSeats and numNorthRiders")
    }
    
    func testGetRiderListRandRiders() {

        // Mock response for north_drivers
        let expectedRiders = [Climber (id: "6", name: "Mock Rider 3", location: "rand_riders", seats: 1),
                              Climber (id: "9", name: "Mock Rider 4", location: "rand_riders", seats: 1)]

        sut.getRiderList(fromLocation: "rand_riders", assignedLocation: "RAND")

        // Assertions
        XCTAssertEqual(sut.randClimbers.count, expectedRiders.count, "The number of rand riders should match")
        XCTAssertEqual(sut.randClimbers.first?.id, expectedRiders.first?.id, "The ID of the rand riders should match")
        XCTAssertEqual(sut.numRandRiders, 2, "The number of seats should be 2")
    }

    
    func testGetDriverListNorthDrivers() {

        // Mock response for north_drivers
        let expectedDrivers = [Driver(id: "1", name: "Mock Driver 1", location: "north_drivers", seats: 3,                           preference: "NORTH"),
                               Driver(id: "2", name: "Mock Driver 2", location: "north_drivers", seats: 2, preference: "NORTH"),
                               Driver(id: "5", name: "Mock Driver 5", location: "north_drivers", seats: 3, preference: "NORTH")]

        sut.getDriverList(fromLocation: "north_drivers", assignedLocation: "NORTH")

        // Assertions
        XCTAssertEqual(sut.northDrivers.count, expectedDrivers.count, "The number of north drivers should match")
        XCTAssertEqual(sut.northDrivers.first?.id, expectedDrivers.first?.id, "The ID of the north driver should match")
        XCTAssertEqual(sut.numNorthSeats, 8, "The number of seats should be 2")
    }
}
