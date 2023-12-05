//
//  AdminPeopleViewUI.swift
//  VccRideUITests
//
//  Created by Karen Pu on 11/18/23.
//

// YOU HAVE TO BE IN ADMIN MODE, SIGNED IN FOR THESE TESTS TO WORK

import XCTest

final class AdminViewUI: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    
    func testAdminPage() throws {
        sleep(2)
            
        let assignButton = app.buttons["Assign Drivers"]
        XCTAssertTrue(assignButton.exists, "Assign drivers does not exist.")
            
        let remindButton = app.buttons["Send Practice Reminder"]
        XCTAssertTrue(remindButton.exists, "Send Practice Reminder does not exist.")
            
        // test people view page
        let peopleView = app.tabBars.buttons["People"]
        XCTAssertTrue(peopleView.exists, "People view did not appear after tapping Calendar button.")
        peopleView.tap()
        
        let roleButton = app.buttons["Filter by Role, Any"]
        XCTAssertTrue(roleButton.exists, "Role filter exists.")
    
        let locationButton = app.buttons["Filter by Location, Any"]
        XCTAssertTrue(roleButton.exists, "Location filter doesn't exists.")
        
        let statusButton = app.buttons["Filter by Status, Any"]
        XCTAssertTrue(roleButton.exists, "Status filter exists.")
        
        statusButton.tap()
        let activeButton = app.buttons["Active"]
        XCTAssertTrue(activeButton.exists, "Rider button exists.")
        activeButton.tap()
        
        let clearFilterButton = app.buttons["Clear Filters"]
        XCTAssertTrue(clearFilterButton.exists, "Clear Filters doesn't exist.")
            
        // testing calendar view page
        let calendarView = app.tabBars.buttons["Calendar"]
        XCTAssertTrue(calendarView.exists, "Calendar view did not appear after tapping Calendar button.")
        calendarView.tap()
        
        let addPractice = app.buttons["Add Practice Date"]
        XCTAssertTrue(addPractice.exists, "Calendar view did not appear after tapping Calendar button.")
        
        // test stats page
        let statsView = app.tabBars.buttons["Stats"]
        XCTAssertTrue(statsView.exists, "Stats view did not appear after tapping Calendar button.")
        statsView.tap()
        
    }
    
    func testDashboardSwipe() throws {
        sleep(2)
        
        let driversNextPractice = app.staticTexts["North Drivers"]
        app.swipeLeft()
        // Check if the driver list page is now present
        XCTAssertTrue(driversNextPractice.exists, "The specific text should exist.")
       
        app.swipeRight()
        app.swipeRight()
        
    }
    
    func testSettingsPage() throws {
        sleep(2)
        // test settings view page
        let settingsView = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsView.exists, "Settings view did not appear after tapping Calendar button.")
        settingsView.tap()
        
        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists, "First Name TextField does not exist")
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists, "Last Name TextField does not exist")
        
        let autoAttendance = app.switches["Automatic Attendance Confirmation"]
        XCTAssertTrue(autoAttendance.exists, "Automatic attendance does not exist.")
        let isOn = autoAttendance.value as! String == "1"
        autoAttendance.tap()
        let isOnAfterTap = autoAttendance.value as! String == "0"
        XCTAssertNotEqual(isOn, isOnAfterTap, "Toggle state did not change after tap")
        
        // Test step up
        let startingValue = 1 // Replace with the actual starting value
        let maximumValue = 5
        
        let stepperIncrementButton = app.buttons["Increment"]
        XCTAssertTrue(stepperIncrementButton.exists, "Stepper increment button does not exist")
        
        // check maximum increments
        for _ in startingValue..<maximumValue {
            stepperIncrementButton.tap()
        }
        
        stepperIncrementButton.tap()

        let stepperBaseLabel = "Available Seats: "
        let maximumValueLabel = "\(stepperBaseLabel)\(maximumValue)"
        XCTAssertTrue(app.staticTexts[maximumValueLabel].exists, "Stepper value exceeded maximum limit")
        
        let savePrefButton = app.buttons["Save Preferences"]
        XCTAssertTrue(savePrefButton.exists, "save preferences button does not exist.")
        
        let signoutButton = app.buttons["Sign Out"]
        XCTAssertTrue(signoutButton.exists, "sign out button does not exist.")
        
        let deleteButton = app.buttons["Delete Account"]
        XCTAssertTrue(deleteButton.exists, "delete button does not exist.")
        
        
        
    }
}
        
