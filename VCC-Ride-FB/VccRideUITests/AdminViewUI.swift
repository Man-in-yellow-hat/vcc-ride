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
        
        // test main page
        let assignButton = app.buttons["Assign Drivers"]
        XCTAssertTrue(assignButton.exists, "Assign drivers does not exist.")
        
        let remindButton = app.buttons["Send Practice Reminder"]
        XCTAssertTrue(remindButton.exists, "Send Practice Reminder does not exist.")
        
        let confirmButton = app.buttons["Confirm Attendance"]
        XCTAssertTrue(confirmButton.exists, "Confirm Attendance does not exist.")
        
        let updateButton = app.buttons["Update Daily Practice"]
        XCTAssertTrue(updateButton.exists, "Update button does not exist.")
        
        
        
        // test people view page
        let peopleView = app.tabBars.buttons["People"]
        XCTAssertTrue(peopleView.exists, "People view did not appear after tapping Calendar button.")
        peopleView.tap()
        
        // testing calendar view page
        let calendarView = app.tabBars.buttons["Calendar"]
        XCTAssertTrue(calendarView.exists, "Calendar view did not appear after tapping Calendar button.")
        calendarView.tap()
        
        // test stats page
        let statsView = app.tabBars.buttons["Stats"]
        XCTAssertTrue(statsView.exists, "Stats view did not appear after tapping Calendar button.")
        statsView.tap()
        
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
        
        
    }
    
    
        
        

//    }
}
        
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
