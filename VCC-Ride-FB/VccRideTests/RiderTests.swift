//
//  RiderTests.swift
//  VccRideTests
//
//  Created by Karen Pu on 11/13/23.
//

import XCTest
@testable import VccRide

class MockDateFetcher: DateFetcher {
    var datesToReturn: [String] = []
    var onFetchDates: (() -> Void)?
    
    func fetchDates(completion: @escaping ([String]?) -> Void) {
        completion(datesToReturn)
        onFetchDates?()
    }
}


final class RiderTests: XCTestCase {
    var sut: PracticeDateViewModel!
    var mockDateFetcher: MockDateFetcher!

    override func setUp() {
        super.setUp()
        mockDateFetcher = MockDateFetcher()
        sut = PracticeDateViewModel(dateFetcher: mockDateFetcher)
    }

    override func tearDown() {
        sut = nil
        mockDateFetcher = nil
        super.tearDown()
    }

    func testFetchExistingDatesEmptyData() {
        // Setup
        mockDateFetcher.datesToReturn = []

        let expectation = XCTestExpectation(description: "FetchDatesEmpty")

        // Modify MockDateFetcher to fulfill expectation after calling completion
        mockDateFetcher.onFetchDates = {
            expectation.fulfill()
        }

        // Act
        sut.fetchExistingDates()

        // Wait
        wait(for: [expectation], timeout: 2.0)

        // Assert
        XCTAssertTrue(sut.practiceDates.isEmpty)
    }
    
    func testFetchExistingDatesUpdatesPracticeDates() {
        // Setup
        let expectedDates = ["Oct10", "Nov03", "Nov25", "Nov17", "Nov13", "Nov11"]
        let orderedDates = ["Oct10", "Nov03", "Nov11", "Nov13", "Nov17", "Nov25",]

        mockDateFetcher.datesToReturn = expectedDates

        let expectation = XCTestExpectation(description: "FetchDatesWithData")

        // Modify MockDateFetcher to fulfill expectation after calling completion
        mockDateFetcher.onFetchDates = {
            expectation.fulfill()
        }

        // Act
        sut.fetchExistingDates()

        // Wait
        wait(for: [expectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(sut.practiceDates, orderedDates)
    }

}
