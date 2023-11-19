//
//  AdminPeopleViewUI.swift
//  VccRideUITests
//
//  Created by Karen Pu on 11/18/23.
//
// YOU HAVE TO BE IN ADMIN MODE, SIGNED IN FOR THESE TESTS TO WORK

import XCTest

final class AdminPeopleViewUI: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testAdminPages() throws {
        sleep(2)
        
        // test main page
        let assignButton = app.buttons["Assign Drivers"]
        XCTAssertTrue(assignButton.exists, "Assign drivers does not exist.")
        
        let remindButton = app.buttons["Send Practice Reminder"]
        XCTAssertTrue(remindButton.exists, "Send Practice Reminder does not exist.")
        
        let confirmButton = app.buttons["Confirm Attendance"]
        XCTAssertTrue(confirmButton.exists, "Confirm Attendance does not exist.")
        
        let updateButton = app.buttons["Update Daily Practice"]
        XCTAssertTrue(updateButton.exists, "Update button does not exist.")

        // test people page
        sleep(2)
        let peopleView = app.tabBars.buttons["People"]
        XCTAssertTrue(peopleView.exists, "People view did not appear after tapping Calendar button.")
        peopleView.tap()
        
        // test calendar page
        let calendarView = app.tabBars.buttons["Calendar"]
        XCTAssertTrue(calendarView.exists, "Calendar view did not appear after tapping Calendar button.")
        calendarView.tap()
        
        // test settings page
        let settingsView = app.tabBars.buttons["Settings"]
        XCTAssertTrue(calendarView.exists, "Settings view did not appear after tapping Calendar button.")
        settingsView.tap()
        
        // test stats page
        let statsView = app.tabBars.buttons["Stats"]
        XCTAssertTrue(calendarView.exists, "Stats view did not appear after tapping Calendar button.")
        statsView.tap()
        
//        let locPicker = app.pickers["LocationPicker"]
//        XCTAssertTrue(locPicker.exists, "Role Picker does not exist")
//
//        // test if driver was selected
//        locPicker.tap()
//
//        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "North")
//        XCTAssertTrue(locPicker.exists, "Role Picker does not exist")
//
//        sleep(1)
//
//        let selectedRoleLabel = app.staticTexts["Picker_North"]
//        XCTAssertTrue(selectedRoleLabel.exists, "Selected role label does not exist")
//        XCTAssertEqual(selectedRoleLabel.label, "North", "Selected role is not North")
    }
}
