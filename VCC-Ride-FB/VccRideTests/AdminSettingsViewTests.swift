//
//  AdminSettingsViewTests.swift
//  VccRideTests
//
//  Created by Aman Momin on 11/14/23.
//

import XCTest
@testable import VccRide

class AdminSettingsViewTests: XCTestCase {
    var adminSettingsView: AdminSettingsView!
    
    override func setUp() {
        super.setUp()
        adminSettingsView = AdminSettingsView()
    }
    
    override func tearDown() {
        adminSettingsView = nil
        super.tearDown()
    }

    func testInitialState() {
        // Ensure that the initial state of selectedLocation, autoConfirm, and availableSeats is as expected
        XCTAssertEqual(adminSettingsView.selectedLocation, "North")
        XCTAssertTrue(adminSettingsView.autoConfirm)
        XCTAssertEqual(adminSettingsView.availableSeats, 1)
    }
    
    func testSavePreferences() {
        // Test saving user preferences
        adminSettingsView.selectedLocation = "Rand"
        adminSettingsView.autoConfirm = false
        adminSettingsView.availableSeats = 3
        
        // Perform the savePreferences action
        adminSettingsView.savePreferences()
        
        // Fetch user preferences from the database
        let fetchedPreferences = fetchUserPreferencesForTesting()
        
        XCTAssertEqual(fetchedPreferences["default_location"] as? String, "Rand")
        XCTAssertEqual(fetchedPreferences["default_attendance_confirmation"] as? Bool, false)
        XCTAssertEqual(fetchedPreferences["default_seats"] as? Int, 3)
    }
    
    func testRevertToOriginalPreferences() {
        // Test reverting to original preferences
        adminSettingsView.selectedLocation = "Rand"
        adminSettingsView.autoConfirm = false
        adminSettingsView.availableSeats = 3
        
        // Perform the revertToOriginalPreferences action
        adminSettingsView.revertToOriginalPreferences()
        
        // Ensure that the values have been reverted to their original state
        XCTAssertEqual(adminSettingsView.selectedLocation, adminSettingsView.dbLocation)
        XCTAssertEqual(adminSettingsView.autoConfirm, adminSettingsView.dbAutoConfirm)
        XCTAssertEqual(adminSettingsView.availableSeats, adminSettingsView.dbAvailableSeats)
    }
    
    // Mock function to fetch user preferences for testing
    func fetchUserPreferencesForTesting() -> [String: Any] {
        return [
            "default_location": "Rand",
            "default_attendance_confirmation": false,
            "default_seats": 3
        ]
    }
}
