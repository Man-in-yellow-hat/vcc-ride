////
////  RiderTests.swift
////  VccRideTests
////
////  Created by Karen Pu on 11/13/23.
////
//
//import XCTest
//@testable import VccRide
//
//class MockFirebaseService: DatabaseServiceProtocol {
//    var datesToReturn: [String: String] = [:]
//    var onFetchDates: (() -> Void)?
//
//    func fetchDates(completion: @escaping ([String: String]) -> Void) {
//        completion(datesToReturn)
//        onFetchDates?()
//    }
//}
//
//final class RiderTests: XCTestCase {
//    var sut: PracticeDateViewModel!
//    var mockFirebaseService: MockFirebaseService!
//
//    override func setUp() {
//        super.setUp()
//        mockFirebaseService = MockFirebaseService()
//        sut = PracticeDateViewModel(databaseService: mockFirebaseService)
//    }
//
//    override func tearDown() {
//        sut = nil
//        mockFirebaseService = nil
//        super.tearDown()
//    }
//
//    func testFetchExistingDatesEmptyData() {
//        // 1. Setup for empty data
//        mockFirebaseService.datesToReturn = [:]
//
//        let expectation = self.expectation(description: "FetchDatesEmpty")
//
//        // 2. Act
//        sut.fetchExistingDates()
//
//        // 3. Expectation
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 2)
//
//        // 4. Assert
//        XCTAssertTrue(self.sut.practiceDates.isEmpty)
//        XCTAssertTrue(self.sut.dateID.isEmpty)
//    }
//
//
//    func testFetchExistingDatesUpdatesPracticeDates() {
//        // Setup
//        let expectedDates = ["Nov03": "id1", "Oct10": "id2", "Nov25": "id3", "Nov17": "id4", "Nov13": "id5", "Nov11": "id6"]
//
//        mockFirebaseService.datesToReturn = expectedDates
//
//        let expectation = XCTestExpectation(description: "fetchDates completes")
//
//        // Modify MockFirebaseService to fulfill expectation after calling completion
//        mockFirebaseService.onFetchDates = {
//            expectation.fulfill()
//        }
//
//        // Act
//        sut.fetchExistingDates()
//
//        // Wait for the expectations to be fulfilled
//        wait(for: [expectation], timeout: 2.0)
//
//        // Assert
//        XCTAssertEqual(sut.practiceDates, expectedDates.keys.sorted())
//        XCTAssertEqual(sut.dateID, expectedDates)
//    }
//
//}
//
