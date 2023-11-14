//
//  AdminCalendarTests.swift
//  VccRideTests
//
//  Created by Aman Momin on 11/14/23.
//

import XCTest
@testable import VccRide
import SwiftUI

// MARK: - MockDateFetcher
class MockDateFetcher: DateFetcher {
    var dates: [String] = ["2023-11-14", "2023-11-15"] // Example dates

    func fetchDates(completion: @escaping ([String]) -> Void) {
        completion(dates)
    }

    func addDate(_ date: String, completion: @escaping (Bool) -> Void) {
        dates.append(date)
        completion(true)
    }

    func deleteDate(_ date: String, completion: @escaping (Bool) -> Void) {
        dates.removeAll { $0 == date }
        completion(true)
    }
}

// MARK: - AdminCalendarTests
class AdminCalendarTests: XCTestCase {
    var viewModel: PracticeDateViewModel!
    var adminCalendar: AdminCalendar!

    override func setUp() {
        super.setUp()
        viewModel = PracticeDateViewModel(dateFetcher: MockDateFetcher())
        adminCalendar = AdminCalendar(practiceDateViewModel: viewModel)
    }

    override func tearDown() {
        viewModel = nil
        adminCalendar = nil
        super.tearDown()
    }

    func testAdminCalendarInitialization() {
        XCTAssertNotNil(adminCalendar)
    }

    func testLoadPracticeDates() {
        let expectation = XCTestExpectation(description: "Fetch practice dates")

        viewModel.fetchExistingDates {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertFalse(viewModel.practiceDates.isEmpty, "Practice dates should not be empty after fetching")
    }

    func testAddPracticeDate() {
        let originalCount = viewModel.practiceDates.count
        viewModel.addPracticeDate(date: "2023-11-16") // Use a test date

        XCTAssertEqual(viewModel.practiceDates.count, originalCount + 1, "New date should be added")
    }

    func testDeletePracticeDate() {
        viewModel.addPracticeDate(date: "2023-11-16")
        let originalCount = viewModel.practiceDates.count
        viewModel.deletePracticeDate(date: "2023-11-16")

        XCTAssertEqual(viewModel.practiceDates.count, originalCount - 1, "Date should be deleted")
    }

    func testDatePickerVisibility() {
        XCTAssertFalse(adminCalendar.datePickerVisible, "Date picker should be initially hidden")
        adminCalendar.datePickerVisible.toggle()
        XCTAssertTrue(adminCalendar.datePickerVisible, "Date picker should be visible after toggling")
    }
}


